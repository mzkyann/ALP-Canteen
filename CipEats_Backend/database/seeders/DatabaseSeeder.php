<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Food;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create seller: Alice
        $user1 = User::factory()->create([
            'name' => 'Alice Seller',
            'email' => 'alice@example.com',
            'password' => Hash::make('password'),
            'role' => 'seller',
            'email_verified_at' => now(),
        ]);

        // Create seller: Bob
        $user2 = User::factory()->create([
            'name' => 'Bob Seller',
            'email' => 'bob@example.com',
            'password' => Hash::make('password'),
            'role' => 'seller',
            'email_verified_at' => now(),
        ]);

        // Create customer: Charlie
        User::factory()->create([
            'name' => 'Charlie Customer',
            'email' => 'charlie@example.com',
            'password' => Hash::make('password'),
            'role' => 'customer',
            'email_verified_at' => now(),
        ]);

        // Create 3 food items for Alice
        Food::factory()->count(3)->create([
            'user_id' => $user1->id,
        ]);

        // Create 2 food items for Bob
        Food::factory()->count(2)->create([
            'user_id' => $user2->id,
        ]);
    }
}
