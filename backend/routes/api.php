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

    Route::prefix('user')->group(function () {

        Route::get('/', 'AuthUserController@get');

        Route::put('/info', 'AuthUserController@updateUser');

        Route::put('/photo', 'UserImageController@update');

        Route::put('/password', 'AuthUserController@updatePassword');

        Route::prefix('recommendations')->group(function () {
            Route::get('/', 'RecommendationController@userRecommendations');
            Route::get('/{id}', 'RecommendationController@recommendation');
            Route::put('/{id}/{recommendation_status}', 'RecommendationController@changeStatus');
        });
    });

    Route::prefix('provider')->group(function () {

        Route::put('/address', 'ProviderAddressController@update');

        Route::prefix('recommendations')->group(function () {
            Route::get('/', 'RecommendationController@providerRecommendations');
            Route::post('/', 'RecommendationController@store');
        });

        Route::prefix('professions')->group(function () {
            Route::get('/', 'ProviderProfessionController@all');
            Route::post('/', 'ProviderProfessionController@create');
            Route::put('/{id}', 'ProviderProfessionController@update');
            Route::delete('/{id}', 'ProviderProfessionController@delete');
        });

        Route::prefix('services')->group(function () {
            Route::get('/', 'ProviderServiceController@all');
            Route::post('/', 'ProviderServiceController@create');
            Route::put('/{id}', 'ProviderServiceController@update');
            Route::delete('/{id}', 'ProviderServiceController@delete');
        });

        Route::prefix('verifies')->group(function () {
            Route::post('/', 'ProviderVerifyController@create');
            Route::delete('/{id}', 'ProviderVerifyController@delete');
        });

        Route::prefix('schedules')->group(function () {
            Route::get('/', 'ProviderScheduleController@all');
            Route::post('/', 'ProviderScheduleController@update');
        });

        Route::prefix('exception-schedules')->group(function () {
            Route::get('/', 'ProviderExceptionScheduleController@all');
            Route::post('/', 'ProviderExceptionScheduleController@create');
            Route::put('/{id}', 'ProviderExceptionScheduleController@update');
            Route::delete('/{id}', 'ProviderExceptionScheduleController@delete');
        });


    });

});

Route::prefix('register')->group(function () {
    Route::post('/provider', 'Auth\Register\ProviderRegisterController@register');
    Route::post('/user', 'Auth\Register\UserRegisterController@register');
});


Route::get('/category/{category}/professions', 'ProfessionsController@professions');

Route::get('/cities', 'CityController@all');
//Get /category/{category_id}/professions ()(professions)
