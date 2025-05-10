<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Models\SellerVerification;
use App\Http\Controllers\Controller;

class SellerVerificationController extends Controller
{
    public function store(Request $request)
    {
        $user = $request->user();
        
        if (!$user->isSeller()) {
            return response()->json([
                'success' => false,
                'message' => 'Only sellers can submit verification'
            ], 403);
        }
        
        if ($user->isVerifiedSeller()) {
            return response()->json([
                'success' => false,
                'message' => 'You are already verified'
            ], 400);
        }
        
        if ($user->hasPendingVerification()) {
            return response()->json([
                'success' => false,
                'message' => 'You already have a pending verification'
            ], 400);
        }
        
        $request->validate([
            'business_name' => 'required|string|max:255|unique:seller_verifications',
        ]);
        
        $verification = SellerVerification::create([
            'user_id' => $user->id,
            'business_name' => $request->business_name,
            'status' => 'pending',
        ]);
        
        return response()->json([
            'success' => true,
            'message' => 'Verification submitted successfully',
            'data' => [
                'business_name' => $verification->business_name,
                'status' => $verification->status,
                'submitted_at' => $verification->created_at,
            ]
        ], 201);
    }
    
    public function status(Request $request)
    {
        $user = $request->user();
        
        if (!$user->isSeller()) {
            return response()->json([
                'success' => false,
                'message' => 'Only sellers can check verification status'
            ], 403);
        }
        
        if (!$user->sellerVerification) {
            return response()->json([
                'success' => false,
                'message' => 'No verification submitted yet'
            ], 404);
        }
        
        return response()->json([
            'success' => true,
            'data' => [
                'business_name' => $user->sellerVerification->business_name,
                'status' => $user->sellerVerification->status,
                'rejection_reason' => $user->sellerVerification->rejection_reason,
                'submitted_at' => $user->sellerVerification->created_at,
            ]
        ]);
    }
    
    // Admin approval endpoint
    public function approve(Request $request, $userId)
    {
        $user = User::findOrFail($userId);
        
        if (!$user->isSeller()) {
            return response()->json([
                'success' => false,
                'message' => 'User is not a seller'
            ], 400);
        }
        
        if (!$user->sellerVerification) {
            return response()->json([
                'success' => false,
                'message' => 'No verification to approve'
            ], 400);
        }
        
        $user->sellerVerification->update([
            'status' => 'approved',
        ]);
        
        $user->update(['is_verified' => true]);
        
        return response()->json([
            'success' => true,
            'message' => 'Seller approved successfully',
            'data' => [
                'user_id' => $user->id,
                'business_name' => $user->sellerVerification->business_name,
                'status' => 'approved',
            ]
        ]);
    }

public function pending()
{
    \Log::debug('Test log: Checking if log works');

    // Debugging step 1: Log a message before querying
    \Log::info('Fetching pending sellers...');

    // Fetching pending seller verifications
    $pendingSellers = SellerVerification::with('user')
        ->where('status', 'pending')
        ->get();
    
    // Debugging step 2: Log the result of the query
    \Log::info('Pending Sellers:', $pendingSellers->toArray());

    return response()->json([
        'success' => true,
        'data' => $pendingSellers
    ]);
}



}