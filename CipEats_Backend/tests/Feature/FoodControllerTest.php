<?php

namespace Tests\Feature;

use App\Models\Food;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class FoodControllerTest extends TestCase
{

    protected $sellerUser;
    protected $buyerUser;

    public function setUp(): void
    {
        parent::setUp();

        $this->sellerUser = User::factory()->create(['role' => 'seller']);
        $this->buyerUser = User::factory()->create(['role' => 'customer']);
    }

    /** @test */
    public function non_authenticated_user_cannot_access_food_routes()
    {
        $response = $this->getJson('/api/v1/seller/food');
        $response->assertStatus(401);
    }

    /** @test */
    public function non_seller_user_gets_forbidden()
    {
        $response = $this->actingAs($this->buyerUser, 'sanctum')->getJson('/api/v1/seller/food');
        $response->assertStatus(403);
    }

    /** @test */
    public function seller_can_list_their_food_items()
    {
        Food::factory()->count(2)->create(['user_id' => $this->sellerUser->id]);
        Food::factory()->create(); // food from another seller

        $response = $this->actingAs($this->sellerUser, 'sanctum')->getJson('/api/v1/seller/food');

        $response->assertStatus(200)
            ->assertJsonCount(2) // only seller's foods
            ->assertJsonStructure([
                '*' => ['id', 'name', 'price', 'description', 'image', 'availability', 'user_id']
            ]);
    }

    /** @test */
    public function seller_can_create_food_with_image()
    {
        Storage::fake('public');

        $file = UploadedFile::fake()->image('food.jpg');

        $response = $this->actingAs($this->sellerUser, 'sanctum')->postJson('/api/v1/seller/food', [
            'name' => 'Test Food',
            'price' => 12.50,
            'description' => 'Delicious test food',
            'image' => $file,
            'availability' => true,
        ]);

        $response->assertStatus(201)
            ->assertJsonFragment(['name' => 'Test Food', 'price' => 12.50]);

        // Assert image was stored
        Storage::disk('public')->assertExists($response->json('image'));

        // Assert in database
        $this->assertDatabaseHas('food', [
            'name' => 'Test Food',
            'user_id' => $this->sellerUser->id
        ]);
    }

    /** @test */
    public function seller_can_view_single_food()
    {
        $food = Food::factory()->create(['user_id' => $this->sellerUser->id]);

        $response = $this->actingAs($this->sellerUser, 'sanctum')->getJson("/api/v1/seller/food/{$food->id}");

        $response->assertStatus(200)
            ->assertJsonFragment(['id' => $food->id]);
    }

    /** @test */
    public function seller_cannot_view_others_food()
    {
        $food = Food::factory()->create(); // belongs to another user

        $response = $this->actingAs($this->sellerUser, 'sanctum')->getJson("/api/v1/seller/food/{$food->id}");

        $response->assertStatus(403);
    }

    /** @test */
    public function seller_can_update_food_with_image_change()
    {
        Storage::fake('public');

        $food = Food::factory()->create([
            'user_id' => $this->sellerUser->id,
            'image' => 'food_images/old_image.jpg'
        ]);

        Storage::disk('public')->put('food_images/old_image.jpg', 'dummy content');

        $newImage = UploadedFile::fake()->image('new_food.jpg');

        $response = $this->actingAs($this->sellerUser, 'sanctum')->putJson("/api/v1/seller/food/{$food->id}", [
            'name' => 'Updated Name',
            'price' => 20,
            'image' => $newImage,
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Food updated successfully']);

        Storage::disk('public')->assertMissing('food_images/old_image.jpg'); // old deleted
        Storage::disk('public')->assertExists($response->json('food.image'));

        $this->assertDatabaseHas('food', [
            'id' => $food->id,
            'name' => 'Updated Name',
            'price' => 20,
        ]);
    }

    /** @test */
    public function seller_can_delete_food_and_image()
    {
        Storage::fake('public');

        $food = Food::factory()->create([
            'user_id' => $this->sellerUser->id,
            'image' => 'food_images/to_delete.jpg'
        ]);

        Storage::disk('public')->put('food_images/to_delete.jpg', 'dummy content');

        $response = $this->actingAs($this->sellerUser, 'sanctum')->deleteJson("/api/v1/seller/food/{$food->id}");

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Food deleted']);

        Storage::disk('public')->assertMissing('food_images/to_delete.jpg');

        $this->assertDatabaseMissing('food', ['id' => $food->id]);
    }

    /** @test */
    public function seller_can_toggle_food_availability()
    {
        $food = Food::factory()->create([
            'user_id' => $this->sellerUser->id,
            'availability' => false
        ]);

        $response = $this->actingAs($this->sellerUser, 'sanctum')->postJson("/api/v1/seller/food/{$food->id}/availability");

        $response->assertStatus(200)
            ->assertJsonFragment(['message' => 'Availability toggled'])
            ->assertJsonPath('food.availability', true);

        $this->assertDatabaseHas('food', [
            'id' => $food->id,
            'availability' => true,
        ]);
    }

    /** @test */
    public function cannot_update_food_of_other_sellers()
    {
        $food = Food::factory()->create(); // another seller's food

        $response = $this->actingAs($this->sellerUser, 'sanctum')->putJson("/api/v1/seller/food/{$food->id}", [
            'name' => 'Hacker attempt'
        ]);

        $response->assertStatus(403);
    }

    /** @test */
    public function cannot_delete_food_of_other_sellers()
    {
        $food = Food::factory()->create(); // another seller's food

        $response = $this->actingAs($this->sellerUser, 'sanctum')->deleteJson("/api/v1/seller/food/{$food->id}");

        $response->assertStatus(403);
    }
}
