<?php

namespace App\Models;
use App\Models\Food;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Food extends Model
{
    use HasFactory;
    protected $table = 'food';

    protected $fillable = [
        'name',
        'description',
        'price',
        'image',
        'availability',
        'user_id',
    ];
        public function cartItems()
    {
        return $this->hasMany(CartItem::class);
    }
        public function user()
    {
        return $this->belongsTo(User::class);
    }

}
