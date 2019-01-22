<?php

use Illuminate\Database\Seeder;

class UserTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        #region UserRoles

        $userRole = collect( [] );

        collect( [
            [ 'title' => 'Провайдер', 'name' => 'provider' ] ,
            [ 'title' => 'Клиент', 'name' => 'client' ] ,
            [ 'title' => 'Администратор', 'name' => 'admin' ] ,
        ] )->each( function( $item ) use ( &$userRole )
        {
            $userRole = $userRole->merge( factory( \App\Models\UserRole::class , 1 )->create( $item ) );
        } );

        #endregion

        #region Users

        $users = factory(\App\Models\User::class, 10)->create();

        #endregion

        #region UserImages

        $userImage = collect( [] );

        $users->random(5)->pluck('id')->each(function ($user_id) use (&$userImage) {
            $userImage = $userImage->merge( factory(\App\Models\UserImage::class, 1)->create([ 'user_id' => $user_id ]) );
        });

        #endregion

    }
}
