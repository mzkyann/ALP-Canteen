<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;


class SellerVerification extends Model
{
    protected $fillable = [
        'user_id', 'business_name', 'status'
    ];
    
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}