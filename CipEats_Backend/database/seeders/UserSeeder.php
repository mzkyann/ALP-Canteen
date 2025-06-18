<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Food;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Seller 1
        $seller1 = User::create([
            'name' => 'Alice Seller',
            'email' => 'alice@example.com',
            'password' => Hash::make('password'),
            'role' => 'seller',
            'email_verified_at' => now(),
        ]);

        // Seller 2
        $seller2 = User::create([
            'name' => 'Bob Seller',
            'email' => 'bob@example.com',
            'password' => Hash::make('password'),
            'role' => 'seller',
            'email_verified_at' => now(),
        ]);

        // Customer
        User::create([
            'name' => 'Charlie Customer',
            'email' => 'charlie@example.com',
            'password' => Hash::make('password'),
            'role' => 'customer',
            'email_verified_at' => now(),
        ]);

        // Makanan untuk seller 1
        Food::factory()->count(3)->create([
            'user_id' => $seller1->id,
        ]);

        // Makanan untuk seller 2
        Food::factory()->count(2)->create([
            'user_id' => $seller2->id,
        ]);
    }
}
