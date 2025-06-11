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

    $request->validate([
        'delivery_method' => 'required|in:pickup,delivery',
        'scheduled_time' => 'nullable|date|after_or_equal:today|before:tomorrow',
    ]);

    $cartItems = \App\Models\CartItem::where('user_id', $user->id)
        ->with(['food', 'prasmanan']) // eager load both relations
        ->get();

    if ($cartItems->isEmpty()) {
        return response()->json(['error' => 'Your cart is empty.'], 400);
    }

    DB::beginTransaction();
    try {
        $totalPrice = 0;

        foreach ($cartItems as $item) {
            if ($item->food) {
                $totalPrice += $item->food->price * $item->quantity;
            } elseif ($item->prasmanan) {
                $totalPrice += $item->prasmanan->price * $item->quantity;
            }
        }

        $order = Order::create([
            'user_id' => $user->id,
            'status' => 'pending',
            'total_price' => $totalPrice,
            'delivery_method' => $request->delivery_method,
            'scheduled_time' => $request->scheduled_time,
        ]);

        foreach ($cartItems as $item) {
            if ($item->food) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'food_id' => $item->food->id,
                    'quantity' => $item->quantity,
                    'seller_id' => $item->food->user_id,
                    'status' => 'pending',
                    'estimated_time' => $item->food->estimated_time,
                    'price' => $item->food->price,
                ]);
            } elseif ($item->prasmanan) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'prasmanan_id' => $item->prasmanan->id,
                    'quantity' => $item->quantity,
                    'seller_id' => $item->prasmanan->user_id,
                    'status' => 'pending',
                    'estimated_time' => $item->prasmanan->estimated_time,
                    'price' => $item->prasmanan->price,
                ]);
            }
        }

        \App\Models\CartItem::where('user_id', $user->id)->delete();

        DB::commit();

        return response()->json([
            'message' => 'Order placed successfully.',
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

    $orders = Order::whereHas('orderItems.food', function ($query) use ($user) {
        $query->where('user_id', $user->id);
    })->with([
        'orderItems' => function ($query) use ($user) {
            $query->whereHas('food', function ($foodQuery) use ($user) {
                $foodQuery->where('user_id', $user->id);
            })->with('food');
        },
        'user'
    ])->get();

    // Adjust total_price to be seller-specific
    $orders->transform(function ($order) {
        // Calculate total only from visible (seller-owned) order items
        $sellerTotal = $order->orderItems->sum(function ($item) {
            return $item->price * $item->quantity;
        });

        // Override total_price field with the correct seller-specific amount
        $order->total_price = number_format($sellerTotal, 2, '.', '');

        return $order;
    });

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

    public function getOrdersByStatus()
    {
        $user = Auth::user();

        if ($user->role !== 'seller') {
            return response()->json(['error' => 'Only sellers can view these orders.'], 403);
        }

        $orders = Order::where('status', 'pending') // Only pending orders
            ->whereHas('orderItems.food', function ($query) use ($user) {
                $query->where('user_id', $user->id);
            })
            ->with([
                'orderItems' => function ($query) use ($user) {
                    $query->whereHas('food', function ($q) use ($user) {
                        $q->where('user_id', $user->id);
                    })->with('food');
                },
                'user'
            ])
            ->get();

        $orders->transform(function ($order) {
            $sellerTotal = $order->orderItems->sum(function ($item) {
                return $item->quantity * $item->price;
            });

            $order->total_price = number_format($sellerTotal, 2, '.', '');

            return $order;
        });

        return response()->json($orders);
    }




public function sellerRevenue(Request $request)
{
    $user = Auth::user();
    $sellerId = auth()->id();

    $query = OrderItem::query()
        ->whereHas('food', function ($q) use ($user) {
            $q->where('user_id', $user->id); // Get seller's food
        })
        ->whereHas('order', function ($q) {
            $q->whereIn('status', ['siap', 'diantar']);
        });

    if ($request->has(['start_date', 'end_date'])) {
        $query->whereHas('order', function ($q) use ($request) {
            $q->whereBetween('created_at', [
                $request->input('start_date'),
                $request->input('end_date'),
            ]);
        });
    }

    // Join orders to get order date for monthly grouping
    $query->join('orders', 'orders.id', '=', 'order_items.order_id');

    $revenue = DB::table('order_items')
        ->join('orders', 'orders.id', '=', 'order_items.order_id')
        ->join('food', 'food.id', '=', 'order_items.food_id')
        ->select(
            DB::raw("DATE_FORMAT(orders.created_at, '%Y-%m') as month"),
            DB::raw("SUM(order_items.quantity * order_items.price) as revenue")
        )
        ->where('food.user_id', $sellerId)
        ->whereIn('orders.status', ['siap', 'diantar'])
        ->groupBy('month')
        ->orderBy('month')
        ->get();


    return response()->json([
        'success' => true,
        'data' => $revenue
    ]);
}


}
