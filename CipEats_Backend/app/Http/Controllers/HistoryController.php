<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Order;

class HistoryController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

    /**
     * Get order history for the authenticated user (seller or customer)
     */
    public function index()
    {
        $user = Auth::user();

        if ($user->role === 'customer') {
            return $this->customerHistory($user->id);
        } elseif ($user->role === 'seller') {
            return $this->sellerHistory($user->id);
        } else {
            return response()->json(['error' => 'Unauthorized role.'], 403);
        }
    }

    /**
     * Customer's completed order history
     */
    protected function customerHistory($userId)
    {
        $orders = Order::where('user_id', $userId)
            ->where('status', 'siap')
            ->with(['orderItems.food', 'orderItems.seller', 'user'])
            ->get();

        return response()->json([
            'message' => 'Customer completed orders',
            'data' => $orders
        ]);
    }

    /**
     * Seller's completed order history
     */
    protected function sellerHistory($userId)
    {
        $orders = Order::where('status', 'siap')
            ->whereHas('orderItems.food', function ($query) use ($userId) {
                $query->where('user_id', $userId);
            })
            ->with([
                'orderItems' => function ($query) use ($userId) {
                    $query->whereHas('food', function ($q) use ($userId) {
                        $q->where('user_id', $userId);
                    })->with('food');
                },
                'user'
            ])
            ->get();

        // Optionally re-calculate total price per seller
        $orders->transform(function ($order) {
            $sellerTotal = $order->orderItems->sum(function ($item) {
                return $item->price * $item->quantity;
            });

            $order->total_price = number_format($sellerTotal, 2, '.', '');
            return $order;
        });

        return response()->json([
            'message' => 'Seller completed orders',
            'data' => $orders
        ]);
    }
}
