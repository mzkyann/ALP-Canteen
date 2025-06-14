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
                'items.*.food_id' => 'required_without:items.*.prasmanan_item_ids|exists:food,id',
                'items.*.prasmanan_item_ids' => 'required_without:items.*.food_id|array|min:1',
                'items.*.prasmanan_item_ids.*' => 'exists:prasmanan_items,id',
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

        // Single item mode
        $request->validate([
            'food_id' => 'required_without:prasmanan_item_ids|exists:food,id',
            'prasmanan_item_ids' => 'required_without:food_id|array|min:1',
            'prasmanan_item_ids.*' => 'exists:prasmanan_items,id',
            'quantity' => 'nullable|integer|min:1|max:20',
        ]);

        $item = $request->only(['food_id', 'prasmanan_item_ids', 'quantity']);

        $cartItem = $this->addItem($userId, $item, true);

        return response()->json([
            'message' => 'Item added to cart',
            'item' => $cartItem,
        ]);
    }

    private function addItem($userId, array $item, $additive = false)
    {
        $quantity = min($item['quantity'] ?? 1, 20);

        if (isset($item['prasmanan_item_ids'])) {
            // Sort and hash prasmanan items for a unique bundle ID
            $sortedIds = collect($item['prasmanan_item_ids'])->sort()->values()->all();
            $prasmananHash = md5(json_encode($sortedIds));

            $cartItem = CartItem::firstOrNew([
                'user_id' => $userId,
                'prasmanan_id' => $prasmananHash,
                'type' => 'prasmanan',
            ]);

            $cartItem->prasmanan_item_ids = $sortedIds;
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
