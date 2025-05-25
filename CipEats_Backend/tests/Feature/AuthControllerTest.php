<?php

namespace Tests\Unit;

use App\Http\Controllers\AuthController;
use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Tests\TestCase;
use Mockery;


class AuthControllerTest extends TestCase
{
    use RefreshDatabase;
    /** @test */
    public function user_can_register_successfully()
    {
        Event::fake();

        $controller = new AuthController();

        $request = new Request([
            'name' => 'Test User',
            'email' => 'test1@example.com',
            'password' => 'password123',
            'role' => 'customer',
        ]);

        $response = $controller->register($request);

        $this->assertEquals(201, $response->status());
        $this->assertEquals('Registration successful', $response->getData()->message);
        $this->assertDatabaseHas('users', [
            'email' => 'test1@example.com',
        ]);

        Event::assertDispatched(Registered::class);
    }

    /** @test */
    public function test_registration_requires_valid_fields()
    {
        // Arrange
        $controller = new AuthController();
        $request = new Request([]); // empty request

        // Act
        $response = $controller->register($request);

        // Assert
        $this->assertEquals(422, $response->getStatusCode());

        $data = $response->getData(true); // true = convert stdClass to array

        $this->assertFalse($data['success']);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('name', $data['errors']);
        $this->assertArrayHasKey('email', $data['errors']);
        $this->assertArrayHasKey('password', $data['errors']);
    }

    /** @test */
    public function user_cannot_login_without_verified_email()
    {
        $user = User::factory()->create([
            'email_verified_at' => null,
            'password' => Hash::make('password123'),
        ]);

        $controller = new AuthController();

        $request = new Request([
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response = $controller->login($request);

        $this->assertEquals(403, $response->status());
        $this->assertEquals('Email not verified. Please verify your email first.', $response->getData()->message);
    }

    /** @test */
    public function user_can_login_with_verified_email()
    {
        $user = User::factory()->create([
            'email_verified_at' => now(),
            'password' => Hash::make('password123'),
        ]);

        $controller = new AuthController();

        Auth::shouldReceive('attempt')
            ->once()
            ->andReturn(true);

        Auth::shouldReceive('user')
            ->andReturn($user);

        $request = new Request([
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response = $controller->login($request);

        $this->assertEquals(200, $response->status());
        $this->assertEquals('Login successful', $response->getData()->message);
    }

    /** @test */
    public function user_can_logout()
    {
        // Arrange
        $mockToken = Mockery::mock();
        $mockToken->shouldReceive('delete')->once()->andReturnTrue();

        $mockUser = Mockery::mock();
        $mockUser->shouldReceive('currentAccessToken')->once()->andReturn($mockToken);

        $mockRequest = Mockery::mock(Request::class);
        $mockRequest->shouldReceive('user')->once()->andReturn($mockUser);

        $controller = new AuthController();

        // Act
        $response = $controller->logout($mockRequest);

        // Assert
        $this->assertEquals(200, $response->status());
        $this->assertEquals('Logged out successfully', $response->getData()->message);
    }
}