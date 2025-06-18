<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Food;
use Illuminate\Http\Request;

class PublicFoodController extends Controller
{
    /**
     * Show all available foods from a specific seller (public access).
     */
    public function foodsBySeller(User $user)
    {
        $foods = Food::where('user_id', $user->id)
                     ->where('availability', true)
                     ->with('user')
                     ->get();

        return response()->json([
            'seller' => $user->only(['id', 'name', 'email']),
            'foods' => $foods,
        ]);
    }
}
