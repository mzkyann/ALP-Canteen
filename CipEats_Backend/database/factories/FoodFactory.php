<?php

namespace Database\Factories;

use App\Models\Food;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class FoodFactory extends Factory
{
    protected $model = Food::class;

    public function definition(): array
    {
    return [
        'name' => $this->faker->word(),
        'description' => $this->faker->sentence(),
        'price' => $this->faker->randomFloat(2, 1, 100),
        'user_id' => User::factory(), // create user dynamically and assign id
        'availability' => 1,
        'image' => 'https://via.placeholder.com/640x480.png/0033cc?text=non',
    ];
    }
}
