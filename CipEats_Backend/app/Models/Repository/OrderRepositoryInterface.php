<?php

namespace App\Models\Repositories;

interface OrderRepositoryInterface
{
    public function getCustomerCompletedOrders(int $userId);
    public function getSellerCompletedOrders(int $userId);
}
