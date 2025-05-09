<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\SellerVerificationController;

Route::prefix('v1')->group(function () {
    // Authentication
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    
    // Authenticated routes
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/user', [AuthController::class, 'user']);
        
        // Seller verification
        Route::prefix('seller')->group(function () {
            Route::post('/verify', [SellerVerificationController::class, 'store']);
            Route::get('/verification-status', [SellerVerificationController::class, 'status']);
        });
        
        // Admin endpoints
        Route::middleware('admin')->group(function () {
            Route::get('/pending-sellers', [SellerVerificationController::class, 'pending']);
            Route::post('/approve-seller/{user}', [SellerVerificationController::class, 'approve']);
        });
    });
});