<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Support\Facades\DB;
use App\Models\OrderItem;
use App\Models\Food;
use App\Models\Cartitem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    /**
     * Place a new order
     */

public function placeOrder(Request $request)
{
    $user = Auth::user();
    if ($user->role !== 'customer') {
        return response()->json(['error' => 'Only customers can place orders.'], 403);
    }

    $cartItems = \App\Models\CartItem::where('user_id', $user->id)->with('food')->get();

    if ($cartItems->isEmpty()) {
        return response()->json(['error' => 'Your cart is empty.'], 400);
    }

    DB::beginTransaction();
    try {
        $totalPrice = 0;

        // Calculate total
        foreach ($cartItems as $cartItem) {
            $food = $cartItem->food;
            $totalPrice += $food->price * $cartItem->quantity;
        }

        // Create order with total
        $order = Order::create([
            'user_id' => $user->id,
            'status' => 'pending',
            'total_price' => $totalPrice,
        ]);

        foreach ($cartItems as $cartItem) {
            $food = $cartItem->food;

            OrderItem::create([
                'order_id' => $order->id,
                'food_id' => $food->id,
                'quantity' => $cartItem->quantity,
                'seller_id' => $food->user_id,
                'status' => 'pending',
                'estimated_time' => $food->estimated_time,
                'price' => $food->price, // Add this if your `order_items` table tracks individual prices
            ]);
        }

        \App\Models\CartItem::where('user_id', $user->id)->delete();

        DB::commit();

        return response()->json([
            'message' => 'Order placed successfully from cart.',
            'order_id' => $order->id,
            'total_price' => $totalPrice,
        ], 201);
    } catch (\Exception $e) {
        DB::rollBack();
        return response()->json(['error' => 'Failed to place order.'], 500);
    }
}

    /**
     * Seller views their own orders (order items only related to them)
     */
public function sellerOrders()
{
    $user = Auth::user();
    if ($user->role !== 'seller') {
        return response()->json(['error' => 'Only sellers can view this.'], 403);
    }

    // Get orders that have items with foods owned by the current seller
    $orders = Order::whereHas('orderItems.food', function ($query) use ($user) {
        $query->where('user_id', $user->id); // food.user_id is the seller
    })->with([
        'orderItems' => function ($query) use ($user) {
            $query->whereHas('food', function ($foodQuery) use ($user) {
                $foodQuery->where('user_id', $user->id); // again, filter by food's seller
            })->with('food');
        },
        'user' // the buyer
    ])->get();

    return response()->json($orders);
}



    /**
     * Customer views their own orders with all items
     */
    public function customerOrders()
    {
        $user = Auth::user();
        if ($user->role !== 'customer') {
            return response()->json(['error' => 'Only customers can view this.'], 403);
        }

        $orders = Order::where('user_id', $user->id)
            ->with(['orderItems.food', 'orderItems.seller', 'user'])
            ->get();

        return response()->json($orders);
    }

    /**
     * Seller updates order item status
     */
public function updateOrderItemStatus(Request $request, $orderItemId)
{
    $user = Auth::user();
    if ($user->role !== 'seller') {
        return response()->json(['error' => 'Only sellers can update order items.'], 403);
    }

    $request->validate([
        'status' => 'required|in:pending,diantar,siap',
    ]);

    // Load the order item with the related food and order
    $orderItem = OrderItem::with(['food', 'order'])->findOrFail($orderItemId);

    // Check if the logged-in user is the seller of the food
    if ($orderItem->food->user_id !== $user->id) {
        return response()->json(['error' => 'Unauthorized to update this order item.'], 403);
    }

    $orderItem->status = $request->input('status');
    $orderItem->save();

    // Update the order status based on all its order items
    $orderItem->order->updateStatusBasedOnItems();

    return response()->json([
        'message' => 'Order item status updated successfully.',
        'order_item' => $orderItem,
        'order_status' => $orderItem->order->status, // optional: return updated order status
    ]);
}

public function updateStatusBasedOnItems()
{
    $statuses = $this->orderItems()->pluck('status')->unique();

    if ($statuses->contains('pending')) {
        $this->status = 'pending';
    } elseif ($statuses->count() === 1 && $statuses->first() === 'siap') {
        $this->status = 'siap';
    } elseif ($statuses->count() === 1 && $statuses->first() === 'diantar') {
        $this->status = 'diantar';
    } else {
        // Mixed statuses or other cases
        // You can choose to set a default or a custom status here
        $this->status = 'in_progress';
    }

    $this->save();
}


}
