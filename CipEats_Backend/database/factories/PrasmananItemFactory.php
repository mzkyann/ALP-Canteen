<?php

namespace Database\Factories;

use App\Models\PrasmananItem;
use Illuminate\Database\Eloquent\Factories\Factory;

class PrasmananItemFactory extends Factory
{
    protected $model = PrasmananItem::class;

    public function definition()
    {
        return [
            'name' => $this->faker->word,
            'price' => $this->faker->numberBetween(1000, 10000),
 
            'user_id' => function () {
                return User::factory()->create(['role' => 'seller'])->id;
            },

        ];
    }
}
