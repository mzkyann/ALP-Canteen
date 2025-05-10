<?php

namespace App\Http\Controllers;

use App\Models\Food;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class FoodController extends Controller
{
    public function __construct()
    {
        // Middleware for authentication
        $this->middleware('auth:sanctum');

        // Middleware to check if the logged-in user is a seller
        $this->middleware(function ($request, $next) {
            $this->authorizeSeller();
            return $next($request);
        });
    }

    protected function authorizeSeller()
    {
        // Ensure the user is a seller
        abort_unless(Auth::user()->role === 'seller', 403, 'Only sellers can access this.');
    }

    public function index()
    {
        // Return food items that belong to the logged-in user (the seller)
        return Food::with('user')->where('user_id', Auth::id())->get();
    }

    public function store(Request $request)
    {
        // Validate incoming request
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric',
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'availability' => 'nullable|boolean',
        ]);

        // Handle image upload if provided
        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('food_images', 'public');
        }

        $data['user_id'] = Auth::id();  // Associate food with the logged-in seller

        // Create the food item and return the response
        return Food::create($data);
    }

    public function show(Food $food)
    {
        // Ensure the food belongs to the logged-in seller
        abort_unless($food->user_id === Auth::id(), 403);

        // Load related user
        $food->load('user');

        return $food;
    }

    public function update(Request $request, $id)
    {
        // Find the food item by ID
        $food = Food::findOrFail($id);

        // Ensure the logged-in seller owns the food item
        abort_unless($food->user_id === Auth::id(), 403);

        // Define validation rules with optional fields
        $validator = Validator::make($request->all(), [
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048', // image is optional
            'name' => 'nullable|string|max:255', // name is optional
            'description' => 'nullable|string', // description is optional
            'price' => 'nullable|numeric', // price is optional
            'availability' => 'nullable|boolean', // availability is optional
        ]);

        // Check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        // Prepare data for updating the food
        $data = [];

        // Only update fields that are provided
        if ($request->has('name')) {
            $data['name'] = $request->name;
        }

        if ($request->has('price')) {
            $data['price'] = $request->price;
        }

        if ($request->has('description')) {
            $data['description'] = $request->description;
        }

        if ($request->has('availability')) {
            $data['availability'] = $request->availability;
        }

        // Handle image upload
        if ($request->hasFile('image')) {
            // Delete old image if exists
            if ($food->image) {
                Storage::disk('public')->delete('food_images/' . basename($food->image));
            }

            // Upload new image
            $image = $request->file('image');
            $imageName = $image->store('food_images', 'public');
            $data['image'] = $imageName;
        }

        // Update the food item
        $food->update($data);

        return response()->json([
            'message' => 'Food updated successfully',
            'food' => $food
        ]);
    }

    public function destroy(Food $food)
    {
        // Ensure the logged-in seller owns the food item
        abort_unless($food->user_id === Auth::id(), 403);

        // Delete image if it exists
        if ($food->image) {
            Storage::disk('public')->delete($food->image);
        }

        // Delete the food item
        $food->delete();

        return response()->json(['message' => 'Food deleted']);
    }

    public function setAvailability(Request $request, Food $food)
    {
        // Ensure the logged-in seller owns the food item
        abort_unless($food->user_id === Auth::id(), 403);

        // Toggle availability
        $food->availability = !$food->availability;
        $food->save();

        return response()->json([
            'message' => 'Availability toggled',
            'food' => $food
        ]);
    }
}
