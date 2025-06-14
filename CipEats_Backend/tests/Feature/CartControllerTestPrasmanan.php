<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Food;
use App\Models\PrasmananItem;
use Illuminate\Foundation\Testing\RefreshDatabase;

class CartControllerTestPrasmanan extends TestCase
{
    use RefreshDatabase;

    private $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create();
    }

    /** @test */
    public function it_allows_adding_food_to_cart()
    {
        $food = Food::factory()->create();

        $response = $this->actingAs($this->user)->postJson('/api/v1/cart', [
            'food_id' => $food->id,
            'quantity' => 2,
        ]);

        $response->assertStatus(200);
        $response->assertJsonPath('item.food_id', $food->id);
    }

    /** @test */
    public function it_allows_adding_custom_prasmanan_to_cart()
    {
        $items = PrasmananItem::factory()->count(3)->create(['user_id' => $this->user->id]);
        $itemIds = $items->pluck('id')->toArray();

        $response = $this->actingAs($this->user)->postJson('/api/v1/cart', [
            'prasmanan_item_ids' => $itemIds,
            'quantity' => 1,
        ]);

        $response->assertStatus(200);
        $response->assertJsonPath('item.prasmanan_item_ids', $itemIds);
    }

    /** @test */
    public function it_allows_adding_food_and_prasmanan_items_at_same_time()
    {
        $food = Food::factory()->create();
        $items = PrasmananItem::factory()->count(2)->create(['user_id' => $this->user->id]);

        $response = $this->actingAs($this->user)->postJson('/api/v1/cart', [
            'food_id' => $food->id,
            'prasmanan_item_ids' => $items->pluck('id')->toArray(),
            'quantity' => 1,
        ]);

        $response->assertStatus(200);
        $response->assertJsonPath('item.food_id', $food->id);
        $response->assertJsonPath('item.prasmanan_item_ids', $items->pluck('id')->toArray());
    }

    /** @test */
    public function it_rejects_add_to_cart_with_invalid_food_id()
    {
        $response = $this->actingAs($this->user)->postJson('/api/v1/cart', [
            'food_id' => 999,
            'quantity' => 1,
        ]);

        $response->assertStatus(422);
    }

    /** @test */
    public function it_rejects_add_to_cart_with_invalid_prasmanan_item_ids()
    {
        $response = $this->actingAs($this->user)->postJson('/api/v1/cart', [
            'prasmanan_item_ids' => [999, 1000],
            'quantity' => 1,
        ]);

        $response->assertStatus(422);
    }

    /** @test */
    public function it_rejects_add_to_cart_with_empty_data()
    {
        $response = $this->actingAs($this->user)->postJson('/api/v1/cart', []);

        $response->assertStatus(422);
    }
}
