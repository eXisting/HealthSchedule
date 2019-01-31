<?php

namespace App\Providers;

use App\Models\ProviderProfession;
use App\Models\ProviderService;
use App\Models\ProviderVerify;
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

        #region UserRecommendation

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

        #endregion

        #region ProviderRecommendation

        $gate->define('provider-create-recommendation', function ($provider, $user_id) {
            /**
             * @var User $provider
             * @var integer $user_id
             */
            return $provider->providerRequests()->where('requests.user_id', $user_id)->exists();
        });

        #endregion

        #region ProviderProfession

        $gate->define('provider-update-profession', function ($provider, $profession) {
            /**
             * @var User $provider
             * @var ProviderProfession $profession
             */
            return $provider->id === $profession->provider_id;
        });

        $gate->define('provider-delete-profession', function ($provider, $profession) {
            /**
             * @var User $provider
             * @var ProviderProfession $profession
             */
            return $provider->id === $profession->provider_id;
        });

        #endregion

        #region ProviderService

        $gate->define('provider-update-service', function ($provider, $service) {
            /**
             * @var User $provider
             * @var ProviderService $service
             */
            return $provider->id === $service->provider_id;
        });

        $gate->define('provider-delete-service', function ($provider, $service) {
            /**
             * @var User $provider
             * @var ProviderService $service
             */
            return $provider->id === $service->provider_id;
        });

        #endregion

        $gate->define('provider-delete-verify', function ($provider, $verify) {
            /**
             * @var User $provider
             * @var ProviderVerify $verify
             */
            return $provider->id === $verify->provider_id;
        });


    }
}
