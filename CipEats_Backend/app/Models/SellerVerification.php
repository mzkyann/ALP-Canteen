<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SellerVerification extends Model
{
    protected $fillable = [
        'user_id', 'business_name', 'status','rejection_reason',
    ];
    
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}