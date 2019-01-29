<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateProviderExperiencesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('provider_experiences', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('provider_id');
            $table->unsignedInteger('profession_id');
            $table->unsignedInteger('city_id');
            $table->string('company_name');
            $table->dateTime('start_at');
            $table->dateTime('end_at');
            $table->timestamps();

            $table->foreign('provider_id')->references('id')->on('users');
            $table->foreign('profession_id')->references('id')->on('professions');
            $table->foreign('city_id')->references('id')->on('cities');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('provider_experiences', function (Blueprint $table) {
            $table->dropForeign('provider_experiences_provider_id_foreign');
            $table->dropForeign('provider_experiences_profession_id_foreign');
            $table->dropForeign('provider_experiences_city_id_foreign');
        });
        Schema::dropIfExists('provider_experiences');
    }
}
