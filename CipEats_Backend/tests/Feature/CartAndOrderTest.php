<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Food;
use App\Models\CartItem;
use App\Models\Order;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CartAndOrderTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $food;

    public function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create();
        $this->food = Food::factory()->create([
            'price' => 10.00
        ]);
    }

    /** @test */
    public function user_can_add_item_to_cart()
    {
        $response = $this->actingAs($this->user)->postJson('/api/cart/add', [
            'food_id' => $this->food->id,
            'quantity' => 2
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['quantity' => 2]);

        $this->assertDatabaseHas('cart_items', [
            'user_id' => $this->user->id,
            'food_id' => $this->food->id,
            'quantity' => 2
        ]);
    }

    /** @test */
    public function user_can_view_cart_items()
    {
        CartItem::create([
            'user_id' => $this->user->id,
            'food_id' => $this->food->id,
            'quantity' => 3
        ]);

        $response = $this->actingAs($this->user)->getJson('/api/cart');

        $response->assertStatus(200)
            ->assertJsonFragment(['quantity' => 3]);
    }

    /** @test */
    public function user_can_update_cart_item()
    {
        $cartItem = CartItem::create([
            'user_id' => $this->user->id,
            'food_id' => $this->food->id,
            'quantity' => 1
        ]);

        $response = $this->actingAs($this->user)->putJson("/api/cart/{$cartItem->id}", [
            'quantity' => 5
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Cart item updated successfully']);

        $this->assertDatabaseHas('cart_items', [
            'id' => $cartItem->id,
            'quantity' => 5
        ]);
    }

    /** @test */
    public function user_can_remove_cart_item()
    {
        $cartItem = CartItem::create([
            'user_id' => $this->user->id,
            'food_id' => $this->food->id,
            'quantity' => 1
        ]);

        $response = $this->actingAs($this->user)->deleteJson("/api/cart/{$cartItem->id}");

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Item removed from cart']);

        $this->assertDatabaseMissing('cart_items', [
            'id' => $cartItem->id
        ]);
    }

    /** @test */
    public function user_can_clear_cart()
    {
        CartItem::factory()->count(3)->create([
            'user_id' => $this->user->id,
            'food_id' => $this->food->id
        ]);

        $response = $this->actingAs($this->user)->deleteJson('/api/cart/clear');

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Cart cleared']);

        $this->assertDatabaseMissing('cart_items', [
            'user_id' => $this->user->id
        ]);
    }

    /** @test */
    public function user_can_place_an_order()
    {
        CartItem::create([
            'user_id' => $this->user->id,
            'food_id' => $this->food->id,
            'quantity' => 2
        ]);

        $response = $this->actingAs($this->user)->postJson('/api/orders/place');

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Order placed successfully']);

        $this->assertDatabaseHas('orders', [
            'user_id' => $this->user->id,
            'total_price' => 20.00
        ]);

        $this->assertDatabaseHas('order_items', [
            'food_id' => $this->food->id,
            'quantity' => 2,
            'price' => 10.00
        ]);

        $this->assertDatabaseMissing('cart_items', [
            'user_id' => $this->user->id
        ]);
    }

    /** @test */
    public function placing_order_with_empty_cart_fails()
    {
        $response = $this->actingAs($this->user)->postJson('/api/orders/place');

        $response->assertStatus(400)
            ->assertJsonFragment(['message' => 'Cart is empty']);
    }
}
