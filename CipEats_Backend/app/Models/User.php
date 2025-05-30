<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable implements MustVerifyEmail
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'phone',
        'address',
        'is_verified',
        'avatar',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_verified' => 'boolean',
    ];

    /**
     * User roles
     */
    const ROLE_CUSTOMER = 'customer';
    const ROLE_SELLER = 'seller';
    const ROLE_ADMIN = 'admin';

    /**
     * Relationship with seller verification
     */
    public function sellerVerification()
    {
        return $this->hasOne(SellerVerification::class);
    }

        public function cartItems()
    {
        return $this->hasMany(CartItem::class);
    }

    // public function foods()
    // {
    //     return $this->hasMany(Food::class);
    // }

    public function isVerifiedSeller()
    {
        return $this->role === self::ROLE_SELLER && $this->is_verified;
    }

        public function isSeller()
    {
        return $this->role === self::ROLE_SELLER;
    }
    
        public function isAdmin(): bool
    {
        return $this->role === self::ROLE_ADMIN;
    }


    public function hasPendingVerification()
    {
        return optional($this->sellerVerification)->status === 'pending';
    }


}