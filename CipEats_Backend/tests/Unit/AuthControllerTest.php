<?php

namespace Tests\Unit;

use App\Http\Controllers\AuthController;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Mockery;
use Tests\TestCase;

class AuthControllerTest extends TestCase
{
    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    public function test_register_validation_fails()
    {
        $request = Mockery::mock(Request::class);
        $request->shouldReceive('all')->andReturn([]);

        $controller = new AuthController();
        $response = $controller->register($request);

        $this->assertEquals(422, $response->status());
        $this->assertFalse($response->getData(true)['success']);
    }

    public function test_login_invalid_credentials()
    {
        $request = Mockery::mock(Request::class);
        $request->shouldReceive('all')->andReturn([
            'email' => 'wrong@example.com',
            'password' => 'invalid'
        ]);
        $request->shouldReceive('only')->with('email', 'password')->andReturn([
            'email' => 'wrong@example.com',
            'password' => 'invalid'
        ]);

        Validator::shouldReceive('make')->once()->andReturnSelf();
        Validator::shouldReceive('fails')->once()->andReturn(false);

        Auth::shouldReceive('attempt')->once()->andReturn(false);

        $controller = new AuthController();
        $response = $controller->login($request);

        $this->assertEquals(401, $response->status());
        $this->assertEquals('Invalid credentials', $response->getData(true)['message']);
    }

    public function test_login_email_not_verified()
    {
        $request = Mockery::mock(Request::class);
        $request->shouldReceive('all')->andReturn([
            'email' => 'user@example.com',
            'password' => 'password'
        ]);
        $request->shouldReceive('only')->andReturn([
            'email' => 'user@example.com',
            'password' => 'password'
        ]);

        Validator::shouldReceive('make')->once()->andReturnSelf();
        Validator::shouldReceive('fails')->once()->andReturn(false);

        $mockUser = Mockery::mock(User::class);
        $mockUser->shouldReceive('hasVerifiedEmail')->andReturn(false);

        Auth::shouldReceive('attempt')->once()->andReturn(true);
        Auth::shouldReceive('user')->andReturn($mockUser);
        Auth::shouldReceive('logout')->once();

        $controller = new AuthController();
        $response = $controller->login($request);

        $this->assertEquals(403, $response->status());
        $this->assertEquals('Email not verified. Please verify your email first.', $response->getData(true)['message']);
    }

public function test_login_success()
{
    // Mock request
    $mockRequest = Mockery::mock(Request::class);
    $mockRequest->shouldReceive('all')->andReturn([
        'email' => 'verified@example.com',
        'password' => 'password123',
    ]);
    $mockRequest->shouldReceive('only')->with('email', 'password')->andReturn([
        'email' => 'verified@example.com',
        'password' => 'password123',
    ]);

    // Mock validator
    Validator::shouldReceive('make')->once()->andReturnSelf();
    Validator::shouldReceive('fails')->once()->andReturn(false);

    // Auth attempt
    Auth::shouldReceive('attempt')->once()->andReturn(true);

    // Create mock user
    $mockUser = Mockery::mock(User::class);

    // These must match real method calls inside login()
    $mockUser->shouldReceive('hasVerifiedEmail')->once()->andReturn(true);

    // Ensure createToken returns an object with plainTextToken
    $mockToken = new \stdClass();
    $mockToken->plainTextToken = 'mock-token';
    $mockUser->shouldReceive('createToken')->once()->with('auth_token')->andReturn($mockToken);

    // Optional: if you use getAttribute('name') or 'email' in response
    $mockUser->shouldReceive('getAttribute')->with('name')->andReturn('John Doe');
    $mockUser->shouldReceive('getAttribute')->with('email')->andReturn('john@example.com');

    $mockUser->shouldReceive('isVerifiedSeller')->once()->andReturn(true);

    // Auth::user returns mock user
    Auth::shouldReceive('user')->andReturn($mockUser);

    // Run controller
    $controller = new AuthController();
    $response = $controller->login($mockRequest);

    // Assertions
    $this->assertEquals(200, $response->status());

    $data = $response->getData(true);
    $this->assertTrue($data['success']);
    $this->assertEquals('Login successful', $data['message']);
    $this->assertEquals('mock-token', $data['data']['token']);
    $this->assertEquals(true, $data['data']['is_verified_seller']);
}



    public function test_logout_success()
    {
        $mockToken = Mockery::mock();
        $mockToken->shouldReceive('delete')->once();

        $mockUser = Mockery::mock(User::class);
        $mockUser->shouldReceive('currentAccessToken')->andReturn($mockToken);

        $mockRequest = Mockery::mock(Request::class);
        $mockRequest->shouldReceive('user')->andReturn($mockUser);

        $controller = new AuthController();
        $response = $controller->logout($mockRequest);

        $this->assertEquals(200, $response->status());
        $this->assertEquals('Logged out successfully', $response->getData(true)['message']);
    }
}
