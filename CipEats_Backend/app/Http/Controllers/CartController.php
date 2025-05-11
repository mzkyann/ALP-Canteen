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
            'quantity' => 'nullable|integer|min:1'
        ]);

        $foodId = $request->food_id;
        $quantity = $request->input('quantity', 1);

        $cartItem = CartItem::where('user_id', Auth::id())
            ->where('food_id', $foodId)
            ->first();

        if ($cartItem) {
            $cartItem->quantity += $quantity;
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
        $request->validate([
            'quantity' => 'required|integer|min:1'
        ]);

        $cartItem = CartItem::where('id', $id)->where('user_id', Auth::id())->firstOrFail();
        $cartItem->quantity = $request->quantity;
        $cartItem->save();

        return response()->json(['message' => 'Cart updated', 'item' => $cartItem]);
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
