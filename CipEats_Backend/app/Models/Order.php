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
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
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
            $this->status = 'in_progress';
        }

        $this->save();
    }
}
