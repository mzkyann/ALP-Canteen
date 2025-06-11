<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Prasmanan extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'description', 'price', 'user_id'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function items()
    {
        return $this->belongsToMany(PrasmananItem::class, 'prasmanan_item_prasmanan');
    }
}
