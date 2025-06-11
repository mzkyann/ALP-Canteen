<?php

namespace App\Http\Controllers;

use App\Models\PrasmananItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

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
        ]);

        $item = PrasmananItem::create([
            'user_id' => Auth::id(),
            'name' => $validated['name'],
            'price' => $validated['price'],
        ]);

        return response()->json(['message' => 'Item created', 'data' => $item]);
    }

    public function update(Request $request, $id)
    {
        $item = PrasmananItem::where('user_id', Auth::id())->findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:100',
            'price' => 'sometimes|required|numeric|min:0',
        ]);

        $item->update($validated);

        return response()->json(['message' => 'Item updated', 'data' => $item]);
    }

    public function destroy($id)
    {
        $item = PrasmananItem::where('user_id', Auth::id())->findOrFail($id);
        $item->delete();

        return response()->json(['message' => 'Item deleted']);
    }
}
