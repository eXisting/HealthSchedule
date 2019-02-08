<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('user_role_id');
            $table->unsignedInteger('address_id')->nullable()->default(null);
            $table->unsignedInteger('city_id')->nullable()->default(null);
            $table->string('first_name');
            $table->string('last_name');
            $table->string('email')->unique();
            $table->string('phone')->unique()->nullable();
            $table->boolean('confirmed_status')->default(false);
            $table->timestamp('email_verified_at')->nullable();
            $table->dateTime('birthday_at')->nullable();
            $table->string('password');
            $table->rememberToken();
            $table->timestamps();

            $table->foreign( 'user_role_id' )->references( 'id' )->on( 'user_roles' );
            $table->foreign( 'address_id' )->references( 'id' )->on( 'addresses' );
            $table->foreign( 'city_id' )->references( 'id' )->on( 'cities' );
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign('users_user_role_id_foreign');
            $table->dropForeign('users_address_id_foreign');
            $table->dropForeign('users_city_id_foreign');
        });
        Schema::dropIfExists('users');
    }
}
