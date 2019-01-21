<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ServicesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('services', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('address_id');
            $table->unsignedInteger('provider_id');
            $table->unsignedInteger('profession_id');
            $table->string('title');
            $table->string('name');
            $table->double('price');
            $table->text('description');
            $table->time('interval');
            $table->timestamps();

            $table->foreign( 'address_id' )->references( 'id' )->on( 'addresses' );
            $table->foreign( 'provider_id' )->references( 'id' )->on( 'users' );
            $table->foreign( 'profession_id' )->references( 'id' )->on( 'professions' );
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('services', function (Blueprint $table) {
            $table->dropForeign('services_address_id_foreign');
            $table->dropForeign('services_provider_id_foreign');
            $table->dropForeign('services_profession_id_foreign');
        });
        Schema::dropIfExists('services');
    }
}
