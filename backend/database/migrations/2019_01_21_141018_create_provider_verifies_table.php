<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProviderVerifiesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('provider_verifies', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('provider_id');
            $table->string('document_path');
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
        Schema::table('provider_verifies', function (Blueprint $table) {
            $table->dropForeign('provider_verifies_provider_id_foreign');
        });
        Schema::dropIfExists('provider_verifies');
    }
}
