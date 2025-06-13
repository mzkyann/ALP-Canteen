<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class PrasmananItem extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'description', 'price', 'user_id', 'image'];


    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function prasmanans()
    {
        return $this->belongsToMany(Prasmanan::class, 'prasmanan_item_prasmanan');
    }
}
