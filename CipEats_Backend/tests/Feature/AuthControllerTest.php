<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Event;
use Illuminate\Auth\Events\Registered;
use Tests\TestCase;

class AuthControllerTest extends TestCase
{
    /** @test */
    public function user_can_register_successfully()
    {
        Event::fake();

        $response = $this->postJson('/api/v1/register', [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'role' => 'customer',
        ]);

        $response->assertStatus(201)
                 ->assertJson([
                     'success' => true,
                     'message' => 'Registration successful',
                 ]);

        $this->assertDatabaseHas('users', [
            'email' => 'test@example.com',
        ]);

        Event::assertDispatched(Registered::class);
    }

    /** @test */
    public function registration_requires_valid_fields()
    {
        $response = $this->postJson('/api/v1/register', []);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['name', 'email', 'password']);
    }

    /** @test */
    public function user_cannot_login_without_verified_email()
    {
        $user = User::factory()->create([
            'email_verified_at' => null,
            'password' => bcrypt('password123'),
        ]);

        $response = $this->postJson('/api/v1/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(403)
                 ->assertJson([
                     'success' => false,
                     'message' => 'Email not verified. Please verify your email first.',
                 ]);
    }

    /** @test */
    public function user_can_login_with_verified_email()
    {
        $user = User::factory()->create([
            'email_verified_at' => now(),
            'password' => bcrypt('password123'),
        ]);

        $response = $this->postJson('/api/v1/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(200)
                 ->assertJson([
                     'success' => true,
                     'message' => 'Login successful',
                 ]);
    }

    /** @test */
    public function user_can_logout()
    {
        $user = User::factory()->create([
            'email_verified_at' => now(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        $response = $this->withHeader('Authorization', "Bearer $token")
                         ->postJson('/api/v1/logout');

        $response->assertStatus(200)
                 ->assertJson([
                     'success' => true,
                     'message' => 'Logged out successfully',
                 ]);
    }
}
