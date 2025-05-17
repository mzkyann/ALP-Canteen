<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('food', function (Blueprint $table) {
            $table->integer('estimated_time')->after('price')->nullable()->comment('Estimated preparation time in minutes');
        });
    }

    public function down(): void
    {
        Schema::table('food', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropColumn(['user_id', 'estimated_time']);
        });
    }
};
