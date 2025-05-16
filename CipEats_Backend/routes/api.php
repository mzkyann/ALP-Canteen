<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\FoodController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\SellerVerificationController;
use Illuminate\Foundation\Auth\EmailVerificationRequest;
use App\Models\User;
use Illuminate\Support\Facades\URL;

Route::prefix('v1')->group(function () {
    // Authentication routes...
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::get('/login', function () {
        return response()->json(['message' => 'Login route placeholder']);
    })->name('login');

    // Email verification route accessible without auth, using signed URL
    Route::get('/email/verify/{id}/{hash}', function ($id, $hash) {
        $user = User::findOrFail($id);

        if ($user->hasVerifiedEmail()) {
            return response()->json(['message' => 'Email already verified']);
        }

        // Verify that the hash matches the email
        if (!hash_equals(sha1($user->getEmailForVerification()), $hash)) {
            return response()->json(['message' => 'Invalid verification link'], 403);
        }

        $user->markEmailAsVerified();
        $user->save();

        return response()->json(['message' => 'Email verified successfully']);
    })->middleware('signed')->name('verification.verify');

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/user', [AuthController::class, 'user']);

        Route::post('/email/verification-notification', function (Request $request) {
            if ($request->user()->hasVerifiedEmail()) {
                return response()->json(['message' => 'Email already verified']);
            }

            $request->user()->sendEmailVerificationNotification();

            return response()->json(['message' => 'Verification email sent']);
        })->middleware('throttle:6,1')->name('verification.send');

        // Cart and Seller routes remain as is...
        Route::get('/cart', [CartController::class, 'index']);
        Route::post('/cart', [CartController::class, 'add']);
        Route::put('/cart/{id}', [CartController::class, 'update']);
        Route::delete('/cart/{id}', [CartController::class, 'remove']);
        Route::delete('/cart', [CartController::class, 'clear']);

        Route::prefix('seller')->group(function () {
            Route::post('/verify', [SellerVerificationController::class, 'store']);
            Route::get('/verification-status', [SellerVerificationController::class, 'status']);
            Route::apiResource('foods', FoodController::class);
            Route::put('/foods/{food}', [FoodController::class, 'update']);
            Route::patch('/foods/{food}/availability', [FoodController::class, 'setAvailability']);
            Route::delete('/foods/{food}', [FoodController::class, 'destroy']);
        });

        Route::middleware('admin')->group(function () {
            Route::get('/pending-sellers', [SellerVerificationController::class, 'pending']);
            Route::post('/approve-seller/{user}', [SellerVerificationController::class, 'approve']);
        });
    });
});