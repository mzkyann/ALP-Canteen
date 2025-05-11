<?php
namespace App\Http\Controllers;

use App\Models\CartItem;
use App\Models\Food;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CartController extends Controller
{
    public function index()
    {
        $cartItems = CartItem::with('food')
            ->where('user_id', Auth::id())
            ->get();

        return response()->json(['data' => $cartItems]);
    }

public function add(Request $request)
{
    $request->validate([
        'food_id' => 'required|exists:food,id',
        'quantity' => 'nullable|integer|min:1|max:20'
    ]);

    $foodId = $request->food_id;
    $quantity = $request->input('quantity', 1);

    $cartItem = CartItem::where('user_id', Auth::id())
        ->where('food_id', $foodId)
        ->first();

    if ($cartItem) {
        $newQuantity = $cartItem->quantity + $quantity;
        $cartItem->quantity = min($newQuantity, 20);
        $cartItem->save();
    } else {
        $cartItem = CartItem::create([
            'user_id' => Auth::id(),
            'food_id' => $foodId,
            'quantity' => $quantity
        ]);
    }

    return response()->json(['message' => 'Item added to cart', 'item' => $cartItem]);
}


public function update(Request $request, $id)
{
    try {
        $request->validate([
            'food_id' => 'nullable|exists:food,id',
            'quantity' => 'nullable|integer|min:1|max:20'
        ]);

        $cartItem = CartItem::where('id', $id)->where('user_id', Auth::id())->firstOrFail();

        if ($request->has('food_id')) {
            $cartItem->food_id = $request->input('food_id');
        }

        if ($request->has('quantity')) {
            $cartItem->quantity = $request->input('quantity');
        }

        $cartItem->save();

        return response()->json(['message' => 'Cart item updated successfully']);
    } catch (ModelNotFoundException $e) {
        return response()->json(['error' => 'Cart item not found'], 404);
    } catch (ValidationException $e) {
        return response()->json(['error' => 'Invalid data', 'details' => $e->errors()], 422);
    } catch (QueryException $e) {
        return response()->json(['error' => 'Database error', 'message' => $e->getMessage()], 500);
    } catch (\Exception $e) {
        return response()->json(['error' => 'Something went wrong', 'message' => $e->getMessage()], 500);
    }
}

    public function remove($id)
    {
        $cartItem = CartItem::where('id', $id)->where('user_id', Auth::id())->firstOrFail();
        $cartItem->delete();

        return response()->json(['message' => 'Item removed from cart']);
    }

    public function clear()
    {
        CartItem::where('user_id', Auth::id())->delete();

        return response()->json(['message' => 'Cart cleared']);
    }
}
