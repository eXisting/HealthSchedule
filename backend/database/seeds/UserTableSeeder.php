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

        $users = factory(\App\Models\User::class, 15)->create();

        #endregion

        #region UserImages

        $userImage = collect([]);

        $users->random(10)->pluck('id')->each(function ($user_id) use (&$userImage) {
            $userImage = $userImage->merge( factory(\App\Models\UserImage::class, 1)->create([ 'user_id' => $user_id ]) );
        });

        #endregion

        #region Categories

        $categories = factory(\App\Models\Category::class, 1)->create();

        #endregion

        #region Professions

        $professions = collect([]);

        $categories->random(1)->pluck('id')->each(function ($category_id) use (&$professions) {
            $professions = $professions->merge( factory(\App\Models\Profession::class, 60)->create([ 'category_id' => $category_id ]) );
        });

        #endregion

        #region RequestStatuses

        $requestStatuses = collect([]);

        collect( [
            [ 'title' => 'Пройдено', 'name' => 'passed'],
            [ 'title' => 'Отклонено', 'name' => 'rejected'],
            [ 'title' => 'Принято', 'name' => 'accepted'],
            [ 'title' => 'Ожидание', 'name' => 'pending'],
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
                $start_time = \Carbon\Carbon::createFromTime(rand(7,11), $this->roundToTheNearestAnything(rand(0,45), 20));
                $end_time = \Carbon\Carbon::createFromTime(rand(13,22), $this->roundToTheNearestAnything(rand(0,45), 20));

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

        #region ProviderExceptionSchedules

        $users->where('user_role_id', \App\Models\UserRole::PROVIDER)->random(rand(2,3))->pluck('id')->each(function ($provider_id) {
            collect([1,2,3,4])->random(rand(1,3))->each(function ($day_count) use ($provider_id) {
                $start_time = \Carbon\Carbon::createFromTime(rand(7,11), $this->roundToTheNearestAnything(rand(0,45), 20));
                $end_time = \Carbon\Carbon::createFromTime(rand(13,22), $this->roundToTheNearestAnything(rand(0,45), 20));
                $exception_at = \Carbon\Carbon::now()->addWeek(1)->addDays($day_count)->toDateTimeString();

                factory(\App\Models\ProviderExceptionSchedule::class, 1)
                    ->create([
                        'provider_id' => $provider_id,
                        'exception_at' => $exception_at,
                        'start_time' => $start_time,
                        'end_time' => $end_time,
                    ]);
            });
        });

        #endregion

        #region ProviderProfessions

        $categoriesArr = \App\Models\Category::query()->whereHas('professions')->with('professions')->get();

        $users->where('user_role_id', \App\Models\UserRole::PROVIDER)->each(function ($user) use ($categoriesArr) {

            $category = $categoriesArr->random(1)->first();

            $count = $category->professions->count();

            if($count) {
                $category->professions->random(rand(2,3))->each(function ($prof) use ($user) {
                    factory(\App\Models\ProviderProfession::class, 1)->create([
                        'provider_id' => $user->id,
                        'profession_id' => $prof->id,
                    ]);
                });
            }
        });

        #endregion

        #region Services

        $services = factory(\App\Models\Service::class, 250)->create();

        #endregion

        #region ProviderServices

        $users->where('user_role_id', \App\Models\UserRole::PROVIDER)->each(function ($provider) use ($services) {
//            $professions = $provider->professions;
            if(count($provider->professions)) {
                $provider->professions->each(function ($prof) use ($provider) {
//                    dd($provider);
                    if(count($prof->services)) {

                        $prof->services->each(function ($service) use ($provider) {
                            factory(\App\Models\ProviderService::class, 25)->create([
                                'provider_id' => $provider->id,
                                'service_id' => $service->id
                            ]);
                        });
                    }
                });
            }
        });

        #endregion

        #region Requests

        $request = factory(\App\Models\Request::class, 60)->create();

        #endregion

    }
    
    private function roundToTheNearestAnything($value, $roundTo)
    {
        $mod = $value%$roundTo;
        return $value+($mod<($roundTo/2)?-$mod:$roundTo-$mod);
    }
}
