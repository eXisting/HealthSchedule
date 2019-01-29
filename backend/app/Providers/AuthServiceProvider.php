<?php

namespace App\Providers;

use App\Models\Recommendation;
use App\Models\User;
use Illuminate\Contracts\Auth\Access\Gate as GateContract;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array
     */
    protected $policies = [
        'App\Model' => 'App\Policies\ModelPolicy',
    ];

    /**
     * Register any authentication / authorization services.
     * @param GateContract $gate
     * @return void
     */
    public function boot(GateContract $gate)
    {
        $this->registerPolicies();

        $gate->define('user-get-recommendation', function ($user, $recommendation) {
            /**
             * @var User $user
             * @var Recommendation $recommendation
             */
            return $user->id === $recommendation->user_id;
        });

        $gate->define('user-update-recommendation', function ($user, $recommendation) {
            /**
             * @var User $user
             * @var Recommendation $recommendation
             */
            return $user->id === $recommendation->user_id;
        });

        $gate->define('provider-create-recommendation', function ($provider, $user_id) {
            /**
             * @var User $provider
             * @var integer $user_id
             */
            return $provider->providerRequests()->where('requests.user_id', $user_id)->exists();
        });
    }
}
