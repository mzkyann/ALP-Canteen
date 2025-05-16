<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Food;
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
        $request->validate([
            'items' => 'required|array|min:1',
            'items.*.food_id' => 'required|exists:foods,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        $user = Auth::user();
        if ($user->role !== 'customer') {
            return response()->json(['error' => 'Only customers can place orders.'], 403);
        }

        $items = $request->input('items');

        // Create order for the customer
        $order = Order::create([
            'user_id' => $user->id,
            'status' => 'pending', // initial order status if any
        ]);

        foreach ($items as $item) {
            $food = Food::findOrFail($item['food_id']);

            OrderItem::create([
                'order_id' => $order->id,
                'food_id' => $food->id,
                'quantity' => $item['quantity'],
                'seller_id' => $food->user_id, // seller linked from food owner
                'status' => 'pending', // initial item status
                'estimated_time' => $food->estimated_time,
            ]);
        }

        return response()->json([
            'message' => 'Order placed successfully',
            'order_id' => $order->id,
        ], 201);
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

        // Get all order items for this seller, grouped by order
        $orders = Order::whereHas('orderItems', function ($query) use ($user) {
            $query->where('seller_id', $user->id);
        })->with(['orderItems' => function ($query) use ($user) {
            $query->where('seller_id', $user->id)->with('food');
        }, 'user'])->get();

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

        $orderItem = OrderItem::findOrFail($orderItemId);

        // Check that this seller owns this order item
        if ($orderItem->seller_id !== $user->id) {
            return response()->json(['error' => 'Unauthorized to update this order item.'], 403);
        }

        $orderItem->status = $request->input('status');
        $orderItem->save();

        return response()->json([
            'message' => 'Order item status updated successfully.',
            'order_item' => $orderItem,
        ]);
    }
}
