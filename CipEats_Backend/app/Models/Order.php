<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Order extends Model
{
    protected $fillable = [
        'user_id',
        'total_price',
        'status',
    ];

    // Customer who placed the order
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Order items for this order
    public function orderItems(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }
}
