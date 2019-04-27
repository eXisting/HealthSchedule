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

Route::post('login', 'Auth\LoginController@login');

Route::prefix('register')->group(function () {
    Route::post('/provider', 'Auth\Register\ProviderRegisterController@register');
    Route::post('/user', 'Auth\Register\UserRegisterController@register');
});

Route::middleware('jwt.auth')->group(function () {
    Route::prefix('services')->group(function () {
        // By city id + category_id as params
        Route::get('/', 'ServiceController@all');
        Route::get('/{service}/providers/{provider}', 'ProviderServiceController@getAllProviderServices');

        // All services
        Route::get('/all/{category}', 'ServiceController@getAllServices');
        Route::get('/{id}', 'ServiceController@getService');
    });

    Route::prefix('user')->group(function () {
        Route::get('/', 'AuthUserController@get');

        Route::put('/info', 'UserController@update');

        Route::put('/photo', 'UserImageController@update');

        Route::put('/password', 'UserController@updatePassword');

        Route::prefix('providers')->group(function () {
            Route::get('/', 'UserController@providers');
            Route::get('/{provider}', 'UserController@provider');
        });

        // Not needed now
        // Route::prefix('recommendations')->group(function () {
        //     Route::get('/', 'UserRecommendationController@recommendations');
        //     Route::get('/{recommendation_id}', 'UserRecommendationController@recommendation');
        //     Route::put('/{recommendation}/{recommendation_status}', 'RecommendationController@changeStatus');
        // });

        Route::prefix('requests')->group(function () {
            Route::get('/', 'UserRequestController@requests');
            Route::get('/{request_id}', 'UserRequestController@request');
            Route::post('/', 'UserRequestController@store');
            Route::put('/{request}/rate', 'UserRequestController@updateRate');
        });
    });

    Route::prefix('provider')->group(function () {
        Route::post('/by-ids', 'ProviderController@getByIds');

        Route::get('/available-times', 'ProviderController@getDateTimes');

        Route::prefix('address')->group(function () {
            Route::get('/', 'ProviderAddressController@getById');
            Route::put('/', 'ProviderAddressController@update');
        });

        Route::prefix('users')->group(function () {
            Route::get('/', 'ProviderController@users');
            Route::get('/{user}', 'ProviderController@user');
        });

        // Not needed now
        // Route::prefix('recommendations')->group(function () {
        //     Route::get('/', 'ProviderRecommendationController@recommendations');
        //     Route::get('/{recommendation_id}', 'ProviderRecommendationController@recommendation');
        //     Route::post('/', 'ProviderRecommendationController@store');
        // });

        Route::prefix('requests')->group(function () {
            Route::get('/', 'ProviderRequestController@requests');
            Route::get('/{request_id}', 'ProviderRequestController@request');
            Route::put('/{request}', 'UserRequestController@update');
            Route::put('/{request}/{request_status}', 'RequestController@changeStatus');
            Route::delete('/{request}', 'UserRequestController@delete');
        });

        Route::prefix('professions')->group(function () {
            Route::get('/', 'ProviderProfessionController@all');
            Route::post('/', 'ProviderProfessionController@create');
            Route::put('/{providerProfession}', 'ProviderProfessionController@update');
            Route::delete('/{providerProfession}', 'ProviderProfessionController@delete');
        });

        Route::prefix('services')->group(function () {
            Route::get('/', 'ProviderServiceController@all');
            // get provider service
            Route::get('/{service}', 'ProviderServiceController@getService');
            Route::post('/', 'ProviderServiceController@create');
            Route::put('/{providerService}', 'ProviderServiceController@update');
            Route::delete('/{providerService}', 'ProviderServiceController@delete');
        });

        // Route::prefix('verifies')->group(function () {
        //     Route::post('/', 'ProviderVerifyController@create');
        //     Route::delete('/{provider_verify}', 'ProviderVerifyController@delete');
        // });

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
