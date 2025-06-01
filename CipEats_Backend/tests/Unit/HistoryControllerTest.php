<?php

namespace Tests\Unit\Http\Controllers;

use Tests\TestCase;
use App\Http\Controllers\HistoryController;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Mockery;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class HistoryControllerTest extends TestCase
{
    protected function tearDown(): void
    {
        Mockery::close();
        parent::tearDown();
    }

    // POSITIVE TESTS

    /** @test */
    public function it_returns_customer_history_when_user_is_customer()
    {
        $user = Mockery::mock(User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('customer');
        $user->shouldReceive('getAttribute')->with('id')->andReturn(1);
        
        Auth::shouldReceive('user')->once()->andReturn($user);
        
        $queryMock = $this->mockOrderQuery();
        $queryMock->shouldReceive('where')->with('user_id', 1)->andReturnSelf();
        $queryMock->shouldReceive('where')->with('status', 'siap')->andReturnSelf();
        $queryMock->shouldReceive('with')->with(['orderItems.food', 'orderItems.seller', 'user'])->andReturnSelf();
        $queryMock->shouldReceive('get')->andReturn(collect([$this->createMockOrder()]));
        
        $controller = new HistoryController();
        $response = $controller->index();
        
        $this->assertEquals(200, $response->status());
        $this->assertEquals('Customer completed orders', $response->getData(true)['message']);
    }

    /** @test */
    public function it_returns_seller_history_when_user_is_seller()
    {
        $user = Mockery::mock(User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('seller');
        $user->shouldReceive('getAttribute')->with('id')->andReturn(2);
        
        Auth::shouldReceive('user')->once()->andReturn($user);
        
        $queryMock = $this->mockOrderQuery();
        $queryMock->shouldReceive('where')->with('status', 'siap')->andReturnSelf();
        $queryMock->shouldReceive('whereHas')->with('orderItems.food', Mockery::type('Closure'))->andReturnSelf();
        $queryMock->shouldReceive('with')->with(Mockery::on(function ($arg) {
            return is_array($arg) && isset($arg['orderItems']);
        }))->andReturnSelf();
        $queryMock->shouldReceive('get')->andReturn(collect([$this->createMockSellerOrder()]));
        
        $controller = new HistoryController();
        $response = $controller->index();
        
        $this->assertEquals(200, $response->status());
        $this->assertEquals('Seller completed orders', $response->getData(true)['message']);
    }

    // NEGATIVE TESTS

    /** @test */
    public function it_returns_403_for_unauthorized_roles()
    {
        $user = Mockery::mock(User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('admin');
        
        Auth::shouldReceive('user')->once()->andReturn($user);
        
        $controller = new HistoryController();
        $response = $controller->index();
        
        $this->assertEquals(403, $response->status());
        $this->assertEquals(['error' => 'Unauthorized role.'], $response->getData(true));
    }

    /** @test */
    public function it_returns_empty_array_when_customer_has_no_orders()
    {
        $user = Mockery::mock(User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('customer');
        $user->shouldReceive('getAttribute')->with('id')->andReturn(1);
        
        Auth::shouldReceive('user')->once()->andReturn($user);
        
        $queryMock = $this->mockOrderQuery();
        $queryMock->shouldReceive('where')->with('user_id', 1)->andReturnSelf();
        $queryMock->shouldReceive('where')->with('status', 'siap')->andReturnSelf();
        $queryMock->shouldReceive('with')->with(['orderItems.food', 'orderItems.seller', 'user'])->andReturnSelf();
        $queryMock->shouldReceive('get')->andReturn(collect());
        
        $controller = new HistoryController();
        $response = $controller->index();
        
        $this->assertEquals(200, $response->status());
        $this->assertCount(0, $response->getData(true)['data']);
    }

    /** @test */
    public function it_returns_empty_array_when_seller_has_no_orders()
    {
        $user = Mockery::mock(User::class);
        $user->shouldReceive('getAttribute')->with('role')->andReturn('seller');
        $user->shouldReceive('getAttribute')->with('id')->andReturn(2);
        
        Auth::shouldReceive('user')->once()->andReturn($user);
        
        $queryMock = $this->mockOrderQuery();
        $queryMock->shouldReceive('where')->with('status', 'siap')->andReturnSelf();
        $queryMock->shouldReceive('whereHas')->with('orderItems.food', Mockery::type('Closure'))->andReturnSelf();
        $queryMock->shouldReceive('with')->with(Mockery::on(function ($arg) {
            return is_array($arg) && isset($arg['orderItems']);
        }))->andReturnSelf();
        $queryMock->shouldReceive('get')->andReturn(collect());
        
        $controller = new HistoryController();
        $response = $controller->index();
        
        $this->assertEquals(200, $response->status());
        $this->assertCount(0, $response->getData(true)['data']);
    }




    // HELPER METHODS

    protected function mockOrderQuery()
    {
        $queryMock = Mockery::mock('Illuminate\Database\Eloquent\Builder');
        $orderMock = Mockery::mock('alias:App\Models\Order');
        $orderMock->shouldReceive('where')->andReturn($queryMock);
        return $queryMock;
    }

    protected function createMockOrder()
    {
        return (object) [
            'id' => 1,
            'user_id' => 1,
            'status' => 'siap',
            'orderItems' => collect(),
            'user' => (object) ['id' => 1, 'name' => 'Test User']
        ];
    }

    protected function createMockSellerOrder()
    {
        $order = (object) [
            'id' => 2,
            'user_id' => 1,
            'status' => 'siap',
            'orderItems' => collect([
                (object) [
                    'id' => 1,
                    'price' => 10.50,
                    'quantity' => 2,
                    'food' => (object) ['id' => 1, 'name' => 'Test Food']
                ]
            ]),
            'user' => (object) ['id' => 1, 'name' => 'Test User']
        ];

        $order->orderItems = $order->orderItems->map(function ($item) {
            $item->price = $item->price;
            $item->quantity = $item->quantity;
            return $item;
        });

        return $order;
    }
}