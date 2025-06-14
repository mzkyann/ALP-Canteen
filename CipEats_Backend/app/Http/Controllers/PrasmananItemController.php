<?php

namespace App\Http\Controllers;

use App\Models\PrasmananItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class PrasmananItemController extends Controller
{
    public function index()
    {
        return PrasmananItem::where('user_id', Auth::id())->get();
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'price' => 'required|numeric|min:0',
            'description' => 'nullable|string',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        // Handle image upload
        $imagePath = $request->file('image')->store('prasmanan_images', 'public');

        $item = PrasmananItem::create([
            'user_id' => Auth::id(),
            'name' => $validated['name'],
            'price' => $validated['price'],
            'description' => $validated['description'] ?? null,
            'image' => $imagePath,
        ]);

        return response()->json(['message' => 'Item created', 'data' => $item]);
    }

    public function update(Request $request, $id)
    {
        $item = PrasmananItem::where('user_id', Auth::id())->findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:100',
            'price' => 'sometimes|required|numeric|min:0',
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        // Handle image update
        if ($request->hasFile('image')) {
            // Delete old image
            if ($item->image) {
                Storage::disk('public')->delete($item->image);
            }

            // Upload new image
            $imagePath = $request->file('image')->store('prasmanan_images', 'public');
            $validated['image'] = $imagePath;
        }

        $item->update($validated);

        return response()->json(['message' => 'Item updated', 'data' => $item]);
    }

    public function destroy($id)
    {
        $item = PrasmananItem::where('user_id', Auth::id())->findOrFail($id);

        // Delete image if it exists
        if ($item->image) {
            Storage::disk('public')->delete($item->image);
        }

        $item->delete();

        return response()->json(['message' => 'Item deleted']);
    }
}
