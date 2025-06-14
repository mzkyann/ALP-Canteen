<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
public function up()
{
    Schema::table('orders', function (Blueprint $table) {
        if (!Schema::hasColumn('orders', 'delivery_method')) {
            $table->enum('delivery_method', ['pickup', 'delivery'])->after('status');
        }

        if (!Schema::hasColumn('orders', 'scheduled_time')) {
            $table->dateTime('scheduled_time')->nullable()->after('delivery_method');
        }
    });
}

public function down(): void
{
    Schema::table('orders', function (Blueprint $table) {
        $table->dropColumn('delivery_method');
        $table->dropColumn('scheduled_time');
    });
}

};
