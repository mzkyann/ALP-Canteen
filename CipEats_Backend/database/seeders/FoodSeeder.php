<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Food;

class FoodSeeder extends Seeder
{
    public function run()
    {
        // Create 2 users
        $user1 = User::factory()->create([
            'name' => 'Alice Seller',
            'email' => 'alice@example.com',
        ]);

        $user2 = User::factory()->create([
            'name' => 'Bob Seller',
            'email' => 'bob@example.com',
        ]);

        // Create 3 food items for user1
        Food::factory()->count(3)->create([
            'user_id' => $user1->id,
        ]);

        // Create 2 food items for user2
        Food::factory()->count(2)->create([
            'user_id' => $user2->id,
        ]);
    }
}
