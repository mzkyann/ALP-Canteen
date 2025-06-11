<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CartItem extends Model
{
    protected $fillable = [
        'user_id',
        'food_id',
        'quantity',
        'type',
        'prasmanan_item_ids',
        'price',

    ];

    protected $casts = [
        'prasmanan_item_ids' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function food()
    {
        return $this->belongsTo(Food::class);
    }

public function prasmanan()
{
    return $this->belongsToMany(PrasmananItem::class, 'cart_item_prasmanan_item');
}
}
