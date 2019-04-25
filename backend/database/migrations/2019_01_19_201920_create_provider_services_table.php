<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProviderServicesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('provider_services', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('address_id');
            $table->unsignedInteger('provider_id');
            $table->unsignedInteger('service_id');
            $table->double('price');
            $table->string('name');
            $table->text('description');
            $table->time('interval');
            $table->timestamps();

            $table->foreign( 'address_id' )->references( 'id' )->on( 'addresses' );
            $table->foreign( 'provider_id' )->references( 'id' )->on( 'users' );
            $table->foreign( 'service_id' )->references( 'id' )->on( 'services' );
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('provider_services', function (Blueprint $table) {
            $table->dropForeign('provider_services_address_id_foreign');
            $table->dropForeign('provider_services_service_id_foreign');
            $table->dropForeign('provider_services_provider_id_foreign');
        });
        Schema::dropIfExists('provider_services');
    }
}
