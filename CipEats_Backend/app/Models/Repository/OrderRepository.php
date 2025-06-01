<?php

namespace App\Models\Repositories;

use App\Models\Order;

class OrderRepository implements OrderRepositoryInterface
{
    public function getCustomerCompletedOrders(int $userId)
    {
        return Order::where('user_id', $userId)
            ->where('status', 'siap')
            ->with(['orderItems.food', 'orderItems.seller', 'user'])
            ->get();
    }

    public function getSellerCompletedOrders(int $userId)
    {
        return Order::where('status', 'siap')
            ->whereHas('orderItems', function ($query) use ($userId) {
                $query->where('seller_id', $userId);
            })
            ->with(['orderItems.food', 'orderItems.seller', 'user'])
            ->get();
    }
}
