<?php

use Illuminate\Http\Request;

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
    Route::get('user', function () {
        return auth('api')->user();
    });

    Route::get('provider', function () {
        return auth('api')->user();
    });
});


Route::get('/category/{category}/professions', 'ProfessionsController@professions');

Route::get('/cities', 'CityController@all');
//Get /category/{category_id}/professions ()(professions)
