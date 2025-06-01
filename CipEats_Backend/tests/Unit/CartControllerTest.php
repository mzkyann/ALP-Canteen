<?php

namespace Tests\Unit;

use App\Http\Controllers\CartController;
use App\Models\CartItem;
use App\Models\User;
use App\Models\Food;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Mockery;
use Tests\TestCase;

class CartControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        // Mock Auth facade id() call
        Auth::shouldReceive('id')->andReturn(42);
        User::factory()->create(['id' => 42]);
    }

    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    /** @test */
    public function it_adds_a_single_item_to_cart_when_not_existing()
    {
        // Create a Food item in DB for validation
        $food = Food::factory()->create();

        // Mock CartItem static methods
        $cartItemMock = Mockery::mock('alias:' . CartItem::class);

        // Expect where() calls chained and returning mock
        $cartItemMock->shouldReceive('where')
            ->once()
            ->with('user_id', 42)
            ->andReturnSelf();

        $cartItemMock->shouldReceive('where')
            ->once()
            ->with('food_id', $food->id)
            ->andReturnSelf();

        // Simulate no existing item found
        $cartItemMock->shouldReceive('first')
            ->once()
            ->andReturn(null);

        // Simulate creating a new CartItem
        $createdItem = (object) ['user_id' => 42, 'food_id' => $food->id, 'quantity' => 2];

        $cartItemMock->shouldReceive('create')
            ->once()
            ->with([
                'user_id' => 42,
                'food_id' => $food->id,
                'quantity' => 2
            ])
            ->andReturn($createdItem);

        $controller = new CartController();

        $request = new Request([
            'food_id' => $food->id,
            'quantity' => 2,
        ]);

        $response = $controller->add($request);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertEquals('Item added to cart', $response->getData()->message);
        $this->assertEquals($createdItem, $response->getData()->item);
    }

    /** @test */
    public function it_updates_existing_cart_item_quantity()
    {
        // Create Food record for validation
        $food = Food::factory()->create();

        $existingCartItem = Mockery::mock();
        $existingCartItem->quantity = 3;
        $existingCartItem->shouldReceive('save')->once();

        $cartItemMock = Mockery::mock('alias:' . CartItem::class);

        // Chain where calls and return mock
        $cartItemMock->shouldReceive('where')
            ->once()
            ->with('user_id', 42)
            ->andReturnSelf();

        $cartItemMock->shouldReceive('where')
            ->once()
            ->with('food_id', $food->id)
            ->andReturnSelf();

        // Return existing item
        $cartItemMock->shouldReceive('first')
            ->once()
            ->andReturn($existingCartItem);

        $controller = new CartController();

        $request = new Request([
            'food_id' => $food->id,
            'quantity' => 10,
        ]);

        $response = $controller->add($request);

        $this->assertEquals(200, $response->getStatusCode());
        $this->assertEquals('Item added to cart', $response->getData()->message);
        // Also check that quantity is updated correctly and capped at 20
        $this->assertEquals(13, $existingCartItem->quantity);
    }

    /** @test */
    public function it_validates_add_request_missing_fields()
    {
        $this->expectException(\Illuminate\Validation\ValidationException::class);

        $controller = new CartController();

        $request = new Request([
            // Missing food_id
            'quantity' => 2,
        ]);

        $controller->add($request);
    }

    /** @test */
    public function it_validates_add_request_multiple_items_format()
    {
        $this->expectException(\Illuminate\Validation\ValidationException::class);

        $controller = new CartController();

        $request = new Request([
            'items' => [
                ['food_id' => 1, 'quantity' => 3],
                ['quantity' => 5], // Missing food_id here
            ],
        ]);

        $controller->add($request);
    }
}
