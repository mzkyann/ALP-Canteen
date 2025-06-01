<?php

namespace Tests\Unit\Http\Controllers;

use Tests\TestCase;
use App\Http\Controllers\OrderController;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Mockery;

class OrderControllerTest extends TestCase
{
    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }


    /** @test */
    public function it_places_order_successfully()
    {
        //
        // 1) ALIAS‐MOCK EVERY MODEL/FACADE BEFORE IT’S EVER USED
        //
        $cartItemAlias  = Mockery::mock('alias:App\Models\CartItem');
        $orderAlias     = Mockery::mock('alias:App\Models\Order');
        $orderItemAlias = Mockery::mock('alias:App\Models\OrderItem');
        $dbAlias        = Mockery::mock('alias:Illuminate\Support\Facades\DB');

        //
        // 2) MOCK Auth::user() => “customer” with id=1
        //
        $user = Mockery::mock(\App\Models\User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('customer');
        $user->shouldReceive('getAttribute')->with('id')->andReturn(1);
        Auth::shouldReceive('user')->once()->andReturn($user);

        //
        // 3) PREPARE A “food” and “cartItem” (stdClass objects)
        //
        $food = new \stdClass();
        $food->id             = 10;
        $food->price          = 5000;
        $food->estimated_time = 30;
        $food->user_id        = 99;

        $cartItem = new \stdClass();
        $cartItem->food_id  = 10;
        $cartItem->quantity = 2;
        $cartItem->food     = $food;

        $cartCollection = collect([$cartItem]);

        //
        // 4) MOCK CartItem::where(...)->with('food')->get() ⟶ $cartCollection
        //
        $cartQuery = Mockery::mock(\Illuminate\Database\Eloquent\Builder::class);
        $cartQuery->shouldReceive('with')
                  ->with('food')
                  ->andReturnSelf();
        $cartQuery->shouldReceive('get')
                  ->andReturn($cartCollection);

        // First “where” call (to fetch items):
        $cartItemAlias->shouldReceive('where')
                      ->with('user_id', 1)
                      ->andReturn($cartQuery)
                      ->once();

        //
        // 5) MOCK DB::beginTransaction(), DB::commit(), DB::rollBack()
        //
        $dbAlias->shouldReceive('beginTransaction')->once();
        $dbAlias->shouldReceive('commit')->once();      // happy path
        $dbAlias->shouldReceive('rollBack')->zeroOrMoreTimes(); 
        // (in a perfect run, rollBack() isn’t called, but this prevents “method does not exist” if it is)

        //
        // 6) MOCK Order::create([...]) ⟶ $createdOrder
        //
        $expectedOrderPayload = [
            'user_id'     => 1,
            'status'      => 'pending',
            'total_price' => 10000, // 5000 * 2
        ];
        $createdOrder = new \stdClass();
        $createdOrder->id = 55;

        $orderAlias->shouldReceive('create')
                   ->with($expectedOrderPayload)
                   ->andReturn($createdOrder)
                   ->once();

        //
        // 7) MOCK OrderItem::create([...]) exactly once
        //
        $expectedOrderItemPayload = [
            'order_id'      => 55,
            'food_id'       => 10,
            'quantity'      => 2,
            'seller_id'     => 99,
            'status'        => 'pending',
            'estimated_time'=> 30,
            'price'         => 5000,
        ];
        $orderItemAlias->shouldReceive('create')
                       ->with($expectedOrderItemPayload)
                       ->andReturnTrue()
                       ->once();

        //
        // 8) MOCK CartItem::where('user_id',1)->delete()
        //     (second “where” call, separate from step 4)
        //
        $cartItemAlias->shouldReceive('where')
                      ->with('user_id', 1)
                      ->andReturnSelf()
                      ->once();

        $cartItemAlias->shouldReceive('delete')
                      ->andReturnTrue()
                      ->once();

        //
        // 9) MAKE A FAKE REQUEST (no extra fields needed)
        //
        $request = Request::create('/order', 'POST');

        //
        // 10) CALL THE CONTROLLER
        //
        $controller = new OrderController();
        $response   = $controller->placeOrder($request);

        //
        // 11) ASSERT A 201 STATUS AND CORRECT JSON PAYLOAD
        //
        $this->assertEquals(201, $response->status());

        $data = $response->getData(true);
        $this->assertEquals('Order placed successfully from cart.', $data['message']);
        $this->assertEquals(10000, $data['total_price']);
        $this->assertEquals(55, $data['order_id']);
    }
    /** @test */
    public function it_fails_when_cart_is_empty()
    {
        $user = Mockery::mock(User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('customer');
        $user->shouldReceive('getAttribute')->with('id')->andReturn(1);
        Auth::shouldReceive('user')->once()->andReturn($user);

        $cartQuery = Mockery::mock('Illuminate\Database\Eloquent\Builder');
        $cartQuery->shouldReceive('with')->with('food')->andReturnSelf();
        $cartQuery->shouldReceive('get')->andReturn(collect());

        $cartModel = Mockery::mock('alias:App\Models\CartItem');
        $cartModel->shouldReceive('where')->with('user_id', 1)->andReturn($cartQuery);

        $request = Request::create('/order', 'POST');
        $controller = new OrderController();
        $response = $controller->placeOrder($request);

        $this->assertEquals(400, $response->status());
        $this->assertEquals('Your cart is empty.', $response->getData(true)['error']);
    }

    /** @test */
    public function it_fails_when_user_is_not_customer()
    {
        $user = Mockery::mock(User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('seller');
        Auth::shouldReceive('user')->once()->andReturn($user);

        $request = Request::create('/order', 'POST');
        $controller = new OrderController();
        $response = $controller->placeOrder($request);

        $this->assertEquals(403, $response->status());
        $this->assertEquals('Only customers can place orders.', $response->getData(true)['error']);
    }
}
