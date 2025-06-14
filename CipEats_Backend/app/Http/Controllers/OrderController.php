<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\CartItem;
use App\Models\PrasmananItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

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

        $cartItems = CartItem::where('user_id', $user->id)->get();

        if ($cartItems->isEmpty()) {
            return response()->json(['error' => 'Your cart is empty.'], 400);
        }

        DB::beginTransaction();

        try {
            $totalPrice = 0;

            foreach ($cartItems as $item) {
                if ($item->food_id) {
                    $totalPrice += $item->food->price * $item->quantity;
                } elseif (!empty($item->prasmanan_item_ids)) {
                    $prasmananItems = PrasmananItem::whereIn('id', $item->prasmanan_item_ids)->get();
                    $bundlePrice = $prasmananItems->sum('price');
                    $totalPrice += $bundlePrice * $item->quantity;
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
                if ($item->food_id) {
                    OrderItem::create([
                        'order_id' => $order->id,
                        'food_id' => $item->food_id,
                        'quantity' => $item->quantity,
                        'seller_id' => $item->food->user_id,
                        'status' => 'pending',
                        'estimated_time' => $item->food->estimated_time,
                        'price' => $item->food->price,
                    ]);
                } elseif (!empty($item->prasmanan_item_ids)) {
                    $prasmananItems = PrasmananItem::whereIn('id', $item->prasmanan_item_ids)->get();

                    OrderItem::create([
                        'order_id' => $order->id,
                        'prasmanan_item_ids' => $item->prasmanan_item_ids,
                        'quantity' => $item->quantity,
                        'price' => $prasmananItems->sum('price'),
                        'seller_id' => $prasmananItems->first()->user_id ?? null,
                        'status' => 'pending',
                        'estimated_time' => $prasmananItems->max('estimated_time'),
                    ]);
                }
            }

            CartItem::where('user_id', $user->id)->delete();

            DB::commit();

            return response()->json([
                'message' => 'Order placed successfully.',
                'order_id' => $order->id,
                'total_price' => $totalPrice,
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Failed to place order.',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Seller views their orders
     */
    public function sellerOrders()
    {
        $user = Auth::user();

        if ($user->role !== 'seller') {
            return response()->json(['error' => 'Only sellers can view this.'], 403);
        }

        $orders = Order::whereHas('orderItems', function ($query) use ($user) {
            $query->where('seller_id', $user->id);
        })->with([
            'orderItems' => function ($query) use ($user) {
                $query->where('seller_id', $user->id)->with(['food']);
            },
            'user'
        ])->get();

        $orders->transform(function ($order) {
            $sellerTotal = $order->orderItems->sum(fn($item) => $item->price * $item->quantity);
            $order->total_price = number_format($sellerTotal, 2, '.', '');
            return $order;
        });

        return response()->json($orders);
    }

    /**
     * Customer views their orders
     */
    public function customerOrders()
    {
        $user = Auth::user();

        if ($user->role !== 'customer') {
            return response()->json(['error' => 'Only customers can view this.'], 403);
        }

        $orders = Order::where('user_id', $user->id)
            ->with(['orderItems.food', 'user'])
            ->get();

        return response()->json($orders);
    }

    /**
     * Update individual order item status
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

        $orderItem = OrderItem::with(['food', 'order'])->findOrFail($orderItemId);

        if ($orderItem->seller_id !== $user->id) {
            return response()->json(['error' => 'Unauthorized.'], 403);
        }

        $orderItem->status = $request->input('status');
        $orderItem->save();

        $orderItem->order->updateStatusBasedOnItems();

        return response()->json([
            'message' => 'Order item status updated.',
            'order_item' => $orderItem,
            'order_status' => $orderItem->order->status,
        ]);
    }

    /**
     * Get seller's pending orders
     */
    public function getOrdersByStatus()
    {
        $user = Auth::user();

        if ($user->role !== 'seller') {
            return response()->json(['error' => 'Only sellers can view this.'], 403);
        }

        $orders = Order::where('status', 'pending')
            ->whereHas('orderItems', function ($query) use ($user) {
                $query->where('seller_id', $user->id);
            })
            ->with([
                'orderItems' => function ($query) use ($user) {
                    $query->where('seller_id', $user->id)->with(['food']);
                },
                'user'
            ])
            ->get();

        $orders->transform(function ($order) {
            $total = $order->orderItems->sum(fn($item) => $item->quantity * $item->price);
            $order->total_price = number_format($total, 2, '.', '');
            return $order;
        });

        return response()->json($orders);
    }

    /**
     * Seller revenue reporting
     */
    public function sellerRevenue(Request $request)
    {
        $user = Auth::user();
        $sellerId = $user->id;

        $query = DB::table('order_items')
            ->join('orders', 'orders.id', '=', 'order_items.order_id')
            ->leftJoin('food', 'food.id', '=', 'order_items.food_id')
            ->where('order_items.seller_id', $sellerId)
            ->whereIn('orders.status', ['siap', 'diantar']);

        if ($request->has(['start_date', 'end_date'])) {
            $query->whereBetween('orders.created_at', [
                $request->input('start_date'),
                $request->input('end_date'),
            ]);
        }

        $revenue = $query
            ->select(
                DB::raw("DATE_FORMAT(orders.created_at, '%Y-%m') as month"),
                DB::raw("SUM(order_items.quantity * order_items.price) as revenue")
            )
            ->groupBy('month')
            ->orderBy('month')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $revenue,
        ]);
    }
}
