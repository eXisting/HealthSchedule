<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class RequestsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('requests', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('user_id');
            $table->unsignedInteger('provider_service_id');
            $table->boolean('status')->nullable()->default(null);
            $table->tinyInteger('rate')->nullable()->default(null);
            $table->text('description');
            $table->dateTime('request_at');
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users');
            $table->foreign('provider_service_id')->references('id')->on('provider_services');
            // $table->foreign('status_id')->references('id')->on('request_statuses');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('requests', function (Blueprint $table) {
            $table->dropForeign('requests_user_id_foreign');
            $table->dropForeign('requests_provider_service_id_foreign');
            // $table->dropForeign('requests_status_id_foreign');
        });
        Schema::dropIfExists('requests');
    }
}
