<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
public function up()
{
    Schema::table('cart_items', function (Blueprint $table) {
        $table->enum('type', ['food', 'prasmanan'])->default('food');
        $table->json('prasmanan_item_ids')->nullable();
        $table->decimal('price', 8, 2)->nullable(); // bundle total price

        // Optional: If 'food_id' should be nullable for prasmanan bundles
        $table->foreignId('food_id')->nullable()->change();
    });
}

public function down()
{
    Schema::table('cart_items', function (Blueprint $table) {
        $table->dropColumn('type');
        $table->dropColumn('prasmanan_item_ids');
        $table->dropColumn('price');
        $table->foreignId('food_id')->nullable(false)->change(); // revert if needed
    });
}


};
