<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OrderItem extends Model
{
    protected $fillable = [
        'order_id',
        'food_id',
        'quantity',
        'price',
        'status',
    ];

    // Belongs to an order
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    // The food item ordered
    public function food(): BelongsTo
    {
        return $this->belongsTo(Food::class);
    }

        public function seller()
    {
        return $this->belongsTo(User::class, 'seller_id');
    }
}
