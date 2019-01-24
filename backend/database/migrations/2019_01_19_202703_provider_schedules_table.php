<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ProviderSchedulesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('provider_schedules', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('provider_id');
            $table->tinyInteger('week_day');
            $table->time('start_time');
            $table->time('end_time');
            $table->boolean('working');
            $table->timestamps();

            $table->foreign( 'provider_id' )->references( 'id' )->on( 'users' );
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('provider_schedules', function (Blueprint $table) {
            $table->dropForeign('provider_schedules_provider_id_foreign');
        });
        Schema::dropIfExists('provider_schedules');
    }
}
