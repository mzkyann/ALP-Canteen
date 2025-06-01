<?php

namespace Tests\Unit;

use App\Http\Controllers\FoodController;
use App\Models\Food;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FoodControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_store_food_creates_record_with_image_and_user_without_gd()
    {
        Storage::fake('public');

        // Create and authenticate a seller user
        $user = User::factory()->create(['role' => 'seller']);
        $this->be($user);

        // Create dummy image file (valid minimal JPEG)
        $tmpFilePath = sys_get_temp_dir() . '/test.jpg';
        file_put_contents($tmpFilePath, base64_decode(
            '/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUQEBIQFhUVFRUVFRUVFRUVFRUVFRUXFhUVFRUYHSggGBolHRUVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OFxAQGy0dHR0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAKAAoAMBIgACEQEDEQH/xAAbAAABBQEBAAAAAAAAAAAAAAAFAgMEBgcBB//EADwQAAIBAwIDBgQEBQQDAAAAAAECAwQFEQYSITEHE0FRImFxgZGhBhQjMqHB0fAUI0Lh8SNi0uHwFjNTkqLC4v/EABoBAAIDAQEAAAAAAAAAAAAAAAABAgMEBQb/xAAuEQACAgEDAgQEBwAAAAAAAAAAAQIRAxIhMRNBURQiYYGRobHwFFHwIjLh8f/aAAwDAQACEQMRAD8A3URsQsQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEIQhCEH/2Q=='
        ));

        $uploadedFile = new UploadedFile(
            $tmpFilePath,
            'test.jpg',
            'image/jpeg',
            null,
            true // test mode, skip real upload checks
        );

        $request = Request::create('/food', 'POST', [
            'name' => 'Burger',
            'price' => 10,
            'description' => 'Yummy',
            'availability' => true,
        ]);
        $request->files->set('image', $uploadedFile);

        $controller = new FoodController();
        $food = $controller->store($request);

        $this->assertDatabaseHas('food', [
            'name' => 'Burger',
            'price' => 10,
            'user_id' => $user->id,
        ]);

        Storage::disk('public')->assertExists($food->image);
    }

    public function test_update_food_only_updates_given_fields()
    {
        $user = User::factory()->create(['role' => 'seller']);
        $this->actingAs($user);

        $food = Food::factory()->create(['user_id' => $user->id, 'price' => 10]);

        $request = Request::create('/food/' . $food->id, 'PUT', ['price' => 15.99]);

        $controller = new FoodController();

        $response = $controller->update($request, $food->id);

        $this->assertEquals(200, $response->status());

        $this->assertDatabaseHas('food', [
            'id' => $food->id,
            'price' => 15.99,
        ]);
    }

    public function test_destroy_food_deletes_food_and_image()
    {
        $user = User::factory()->create(['role' => 'seller']);
        $this->actingAs($user);

        Storage::fake('public');

        $food = Food::factory()->create([
            'user_id' => $user->id,
            'image' => 'food_images/test.jpg',
        ]);

        // Pretend the image file exists on disk
        Storage::disk('public')->put('food_images/test.jpg', 'fake content');

        $controller = new FoodController();

        $response = $controller->destroy($food);

        $this->assertEquals(200, $response->status());

        // Assert file deleted
        Storage::disk('public')->assertMissing('food_images/test.jpg');

        // Assert food deleted
        $this->assertDatabaseMissing('food', ['id' => $food->id]);
    }

    public function test_set_availability_flips_boolean()
    {
        $user = User::factory()->create(['role' => 'seller']);
        $this->actingAs($user);

        $food = Food::factory()->create([
            'user_id' => $user->id,
            'availability' => true,
        ]);

        $request = Request::create('/food/' . $food->id . '/setAvailability', 'PATCH');

        $controller = new FoodController();

        $response = $controller->setAvailability($request, $food);

        $this->assertEquals(200, $response->status());

        // Reload fresh from DB
        $food->refresh();

        // Assert availability flipped to false (allow for 0 or false)
        $this->assertFalse((bool) $food->availability);
    }
    public function test_store_food_fails_validation()
{
    $user = User::factory()->create(['role' => 'seller']);
    $this->actingAs($user);

    $request = Request::create('/food', 'POST', [
        'price' => 'invalid', // Missing name, and price is invalid
    ]);

    $controller = new FoodController();

    $this->expectException(\Illuminate\Validation\ValidationException::class);
    $controller->store($request);
}

public function test_store_food_unauthorized_user()
{
    $user = User::factory()->create(['role' => 'customer']);
    $response = $this->actingAs($user)->postJson('/api/food', [
        'name' => 'Burger',
        'price' => 10,
    ]);

    $response->assertStatus(404);
}


public function test_update_food_fails_validation()
{
    $user = User::factory()->create(['role' => 'seller']);
    $this->actingAs($user);

    $food = Food::factory()->create(['user_id' => $user->id]);

    $request = Request::create('/food/' . $food->id, 'PUT', [
        'price' => 'invalid_price'
    ]);

    $controller = new FoodController();

    $response = $controller->update($request, $food->id);

    $this->assertEquals(422, $response->status());
    $this->assertDatabaseHas('food', [
        'id' => $food->id,
        'price' => $food->price, // Should not have changed
    ]);
}

public function test_update_food_unauthorized_user()
{
    $seller = User::factory()->create(['role' => 'seller']);
    $otherUser = User::factory()->create(['role' => 'seller']);
    $this->actingAs($otherUser);

    $food = Food::factory()->create(['user_id' => $seller->id]);

    $request = Request::create('/food/' . $food->id, 'PUT', [
        'price' => 20,
    ]);

    $controller = new FoodController();

    $this->expectException(\Symfony\Component\HttpKernel\Exception\HttpException::class);
    $controller->update($request, $food->id);
}

public function test_destroy_food_unauthorized_user()
{
    $seller = User::factory()->create(['role' => 'seller']);
    $otherUser = User::factory()->create(['role' => 'seller']);
    $this->actingAs($otherUser);

    $food = Food::factory()->create(['user_id' => $seller->id]);

    $controller = new FoodController();

    $this->expectException(\Symfony\Component\HttpKernel\Exception\HttpException::class);
    $controller->destroy($food);
}

public function test_set_availability_unauthorized_user()
{
    $seller = User::factory()->create(['role' => 'seller']);
    $otherUser = User::factory()->create(['role' => 'seller']);
    $this->actingAs($otherUser);

    $food = Food::factory()->create([
        'user_id' => $seller->id,
        'availability' => true,
    ]);

    $request = Request::create('/food/' . $food->id . '/setAvailability', 'PATCH');

    $controller = new FoodController();

    $this->expectException(\Symfony\Component\HttpKernel\Exception\HttpException::class);
    $controller->setAvailability($request, $food);
}
}
