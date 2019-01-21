<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ProviderExceptionScheduleTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('provider_exception_schedule', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('provider_id');
            $table->timestamp('exception_at');
            $table->timestamp('start_time');
            $table->timestamp('end_time');
            $table->boolean('working');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('provider_exception_schedule');
    }
}
