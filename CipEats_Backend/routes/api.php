<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\FoodController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\SellerVerificationController;

Route::prefix('v1')->group(function () {
    // Authentication
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    
    // Authenticated routes
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/user', [AuthController::class, 'user']);
        
        Route::get('/cart', [CartController::class, 'index']);
        Route::post('/cart', [CartController::class, 'add']);
        Route::put('/cart/{id}', [CartController::class, 'update']);
        Route::delete('/cart/{id}', [CartController::class, 'remove']);
        Route::delete('/cart', [CartController::class, 'clear']);

        // Seller verification
        Route::prefix('seller')->group(function () {
            Route::post('/verify', [SellerVerificationController::class, 'store']);
            Route::get('/verification-status', [SellerVerificationController::class, 'status']);
            Route::apiResource('foods', FoodController::class);
            Route::put('/foods/{food}', [FoodController::class, 'update']);
            Route::patch('/foods/{food}/availability', [FoodController::class, 'setAvailability']);
            Route::delete('/foods/{food}', [FoodController::class, 'destroy']);

        });
        
        // Admin endpoints
        Route::middleware('admin')->group(function () {
            Route::get('/pending-sellers', [SellerVerificationController::class, 'pending']);
            Route::post('/approve-seller/{user}', [SellerVerificationController::class, 'approve']);
        });
    });
});