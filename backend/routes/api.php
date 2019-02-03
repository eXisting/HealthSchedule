<?php

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/tests', function () {
    dd(\App\Models\User::query()->find(16));
});

Route::post('login', 'Auth\LoginController@login');

Route::prefix('register')->group(function () {
    Route::post('/provider', 'Auth\Register\ProviderRegisterController@register');
    Route::post('/user', 'Auth\Register\UserRegisterController@register');
});

Route::middleware('jwt.auth')->group(function () {

    Route::prefix('user')->group(function () {

        Route::get('/', 'AuthUserController@get');

        Route::put('/info', 'UserController@update');

        Route::put('/photo', 'UserImageController@update');

        Route::put('/password', 'UserController@updatePassword');

        Route::prefix('recommendations')->group(function () {
            Route::get('/', 'UserRecommendationController@recommendations');
            Route::get('/{recommendation_id}', 'UserRecommendationController@recommendation');
            Route::put('/{recommendation}/{recommendation_status}', 'RecommendationController@changeStatus');
        });
    });

    Route::prefix('provider')->group(function () {

        Route::put('/address', 'ProviderAddressController@update');

        Route::prefix('recommendations')->group(function () {
            Route::get('/', 'ProviderRecommendationController@recommendations');
            Route::get('/{recommendation_id}', 'ProviderRecommendationController@recommendation');
            Route::post('/', 'ProviderRecommendationController@store');
        });

        Route::prefix('professions')->group(function () {
            Route::get('/', 'ProviderProfessionController@all');
            Route::post('/', 'ProviderProfessionController@create');
            Route::put('/{providerProfession}', 'ProviderProfessionController@update');
            Route::delete('/{providerProfession}', 'ProviderProfessionController@delete');
        });

        Route::prefix('services')->group(function () {
            Route::get('/', 'ProviderServiceController@all');
            Route::post('/', 'ProviderServiceController@create');
            Route::put('/{providerService}', 'ProviderServiceController@update');
            Route::delete('/{providerService}', 'ProviderServiceController@delete');
        });

        Route::prefix('verifies')->group(function () {
            Route::post('/', 'ProviderVerifyController@create');
            Route::delete('/{provider_verify}', 'ProviderVerifyController@delete');
        });

        Route::prefix('schedules')->group(function () {
            Route::get('/', 'ProviderScheduleController@all');
            Route::put('/', 'ProviderScheduleController@update');
        });

        Route::prefix('exception-schedules')->group(function () {
            Route::get('/', 'ProviderExceptionScheduleController@all');
            Route::post('/', 'ProviderExceptionScheduleController@create');
            Route::put('/{exceptionSchedule}', 'ProviderExceptionScheduleController@update');
            Route::delete('/{exceptionSchedule}', 'ProviderExceptionScheduleController@delete');
        });


    });

});

Route::get('/category/{category}/professions', 'ProfessionsController@professions');

Route::get('/cities', 'CityController@all');
//Get /category/{category_id}/professions ()(professions)
