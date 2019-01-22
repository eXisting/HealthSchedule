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

        $userImage = collect([]);

        $users->random(5)->pluck('id')->each(function ($user_id) use (&$userImage) {
            $userImage = $userImage->merge( factory(\App\Models\UserImage::class, 1)->create([ 'user_id' => $user_id ]) );
        });

        #endregion

        #region Categories

        $categories = factory(\App\Models\Category::class, 10)->create();

        #endregion

        #region Professions

        $professions = collect([]);

        $categories->random(8)->pluck('id')->each(function ($category_id) use (&$professions) {
            $professions = $professions->merge( factory(\App\Models\Profession::class, 6)->create([ 'category_id' => $category_id ]) );
        });

        #endregion

        #region RequestStatuses

        $requestStatuses = collect([]);

        collect( [
            [ 'title' => 'Принято', 'name' => 'accepted' ] ,
            [ 'title' => 'Отклонено', 'name' => 'rejected' ] ,
            [ 'title' => 'Пройдено', 'name' => 'passed' ] ,
        ] )->each( function( $item ) use ( &$requestStatuses )
        {
            $requestStatuses = $requestStatuses->merge( factory( \App\Models\RequestStatus::class , 1 )->create( $item ) );
        } );

        #endregion

        #region Recommendations

        $recommendations = factory(\App\Models\Recommendation::class, 10)->create();

        #endregion

        #region ProviderVerifies

        $providerVerifies = collect([]);

        $users->where('user_role_id', \App\Models\UserRole::PROVIDER)->pluck('id')->each(function ($provider_id) use (&$providerVerifies) {
            $providerVerifies = $providerVerifies->merge( factory(\App\Models\ProviderVerify::class, rand(1,3))->create([ 'provider_id' => $provider_id ]) );
        });

        #endregion

        #region ProviderSchedules

        $users->where('user_role_id', \App\Models\UserRole::PROVIDER)->pluck('id')->each(function ($provider_id) {
            for ($weekday=0; $weekday<=6; $weekday++) {
                $start_time = \Carbon\Carbon::createFromTime(rand(7,11), rand(0,45));
                $end_time = \Carbon\Carbon::createFromTime(rand(13,22), rand(0,45));

                factory(\App\Models\ProviderSchedule::class, 1)
                    ->create([
                        'provider_id' => $provider_id,
                        'week_day' => $weekday,
                        'start_time' => $start_time,
                        'end_time' => $end_time,
                    ]);
            }
        });

        #endregion
    }
}
