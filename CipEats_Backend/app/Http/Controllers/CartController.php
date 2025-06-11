<?php

namespace App\Http\Controllers;

use App\Models\CartItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;

class CartController extends Controller
{
    public function index()
    {
        $cartItems = CartItem::with(['food', 'prasmanan'])
            ->where('user_id', Auth::id())
            ->get();

        return response()->json(['data' => $cartItems]);
    }

    public function add(Request $request)
    {
        $userId = Auth::id();

        // Multi-item mode
        if ($request->has('items')) {
            $request->validate([
                'items' => 'required|array|min:1',
                'items.*.food_id' => 'required_without:items.*.prasmanan_id|exists:food,id',
                'items.*.prasmanan_id' => 'required_without:items.*.food_id|exists:prasmanans,id',
                'items.*.quantity' => 'nullable|integer|min:1|max:20',
            ]);

            $addedItems = [];

            foreach ($request->items as $item) {
                $addedItems[] = $this->addItem($userId, $item, false);
            }

            return response()->json([
                'message' => 'Items added to cart',
                'items' => $addedItems,
            ]);
        }

        // Single item mode (including prasmanan bundle)
        $request->validate([
            'food_id' => 'required_without:prasmanan_item_ids|exists:food,id',
            'prasmanan_item_ids' => 'required_without:food_id|array|min:1',
            'prasmanan_item_ids.*' => 'exists:prasmanan_items,id',
            'quantity' => 'nullable|integer|min:1|max:20',
        ]);

        $item = $request->only(['food_id', 'quantity']);

        // Handle prasmanan bundle by generating a hash or using a surrogate ID
        if ($request->filled('prasmanan_item_ids')) {
            // You could optionally sort and hash the item IDs for uniqueness
            $prasmananHash = md5(json_encode(collect($request->prasmanan_item_ids)->sort()->values()));
            $item['prasmanan_id'] = $prasmananHash; // This assumes CartItem accepts hashed string ID or a surrogate
        }

        $cartItem = $this->addItem($userId, $item, true);

        return response()->json([
            'message' => 'Item added to cart',
            'item' => $cartItem,
        ]);
    }

    private function addItem($userId, array $item, $additive = false)
    {
        $quantity = min($item['quantity'] ?? 1, 20);

        if (isset($item['prasmanan_id'])) {
            $cartItem = CartItem::firstOrNew([
                'user_id' => $userId,
                'prasmanan_id' => $item['prasmanan_id'],
                'type' => 'prasmanan',
            ]);

            if (isset($item['prasmanan_item_ids'])) {
                $cartItem->prasmanan_item_ids = $item['prasmanan_item_ids'];
            }

        } else {
            $cartItem = CartItem::firstOrNew([
                'user_id' => $userId,
                'food_id' => $item['food_id'],
                'type' => 'food',
            ]);
        }

        $cartItem->quantity = $additive && $cartItem->exists
            ? min($cartItem->quantity + $quantity, 20)
            : $quantity;

        $cartItem->save();

        return $cartItem->load(['food', 'prasmanan']);
    }

    public function update(Request $request, $id)
    {
        try {
            $request->validate([
                'quantity' => 'required|integer|min:1|max:20',
            ]);

            $cartItem = CartItem::where('id', $id)
                ->where('user_id', Auth::id())
                ->firstOrFail();

            $cartItem->quantity = $request->quantity;
            $cartItem->save();

            return response()->json(['message' => 'Cart item updated successfully']);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Cart item not found'], 404);
        } catch (ValidationException $e) {
            return response()->json(['error' => 'Invalid data', 'details' => $e->errors()], 422);
        } catch (QueryException $e) {
            return response()->json(['error' => 'Database error', 'message' => $e->getMessage()], 500);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Unexpected error', 'message' => $e->getMessage()], 500);
        }
    }

    public function remove($id)
    {
        try {
            $cartItem = CartItem::where('id', $id)
                ->where('user_id', Auth::id())
                ->firstOrFail();

            $cartItem->delete();

            return response()->json(['message' => 'Item removed from cart']);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Cart item not found'], 404);
        }
    }

    public function clear()
    {
        CartItem::where('user_id', Auth::id())->delete();

        return response()->json(['message' => 'Cart cleared']);
    }
}
