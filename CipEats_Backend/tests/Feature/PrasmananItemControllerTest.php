<?php

// tests/Feature/PrasmananItemControllerTest.php

namespace Tests\Feature;

use App\Models\User;
use App\Models\PrasmananItem;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PrasmananItemControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_seller_can_list_their_prasmanan_items()
    {
        $seller = User::factory()->create(['role' => 'seller']);
        PrasmananItem::factory()->count(3)->for($seller)->create();

        $this->actingAs($seller)
            ->getJson('/api/v1/seller/prasmanan-items')
            ->assertOk()
            ->assertJsonCount(3, 'data');
    }

    public function test_seller_cannot_see_others_prasmanan_items()
    {
        $seller1 = User::factory()->create(['role' => 'seller']);
        $seller2 = User::factory()->create(['role' => 'seller']);
        PrasmananItem::factory()->count(2)->for($seller2)->create();

        $this->actingAs($seller1)
            ->getJson('/api/v1/seller/prasmanan-items')
            ->assertOk()
            ->assertJsonCount(0, 'data');
    }

    public function test_seller_can_create_prasmanan_item()
    {
        $seller = User::factory()->create(['role' => 'seller']);

        $payload = [
            'name' => 'Tempe Goreng',
            'price' => 5000,
        ];

        $this->actingAs($seller)
            ->postJson('/api/v1/seller/prasmanan-items', $payload)
            ->assertCreated()
            ->assertJsonPath('data.name', 'Tempe Goreng');
    }
}
