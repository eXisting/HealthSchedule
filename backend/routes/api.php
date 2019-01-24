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

//Route::middleware('auth:api')->get('/user', function (Request $request) {
//    return $request->user();
//});
// Route::middleware('jwt.auth')->get('user', function () {

//     return auth('api')->user();
// });
/**
 * Auth routing
 */
Route::post('login', 'Auth\LoginController@login');
Route::post('register/client', 'Auth\RegisterController@registerClient');
Route::post('register/provider', 'Auth\RegisterController@registerProvider');

Route::get('user', 'UsersController@user');
Route::update('user', 'UsersController@updateClient');
Route::update('provider', 'UsersController@updateProvider');
Route::get('services', 'ServicesController@services');
Route::prefix('providers')->group(function () {
    Route::get('/', 'ProvidersController@providers');
    Route::get('/{provider_id}', 'ProvidersController@provider');
});
Route::post('request', 'RequestsController@store');
Route::prefix('history')->group(function () {
    Route::get('/', 'RequestsController@history');
    Route::get('/provider/{provider_id}', 'ProvidersController@info');

    Route::get('/provider/{provider_id}/recommendations', 'RecommendationsController@providerRecommendations');
    Route::get('/provider/{provider_id}/recommendations/{recommendation_id}', 'RecommendationsController@providerRecommendation');
    Route::get('/provider/{provider_id}/recommendations/{recommendation_id}/approve', 'RecommendationsController@approve');
    Route::get('/provider/{provider_id}/recommendations/{recommendation_id}/reject', 'RecommendationsController@reject');

    Route::get('/provider/{provider_id}/requests', 'RequestsController@providerRequests');
    Route::get('/provider/{provider_id}/requests/{request_id}', 'RequestsController@providerRequest');
});
Route::prefix('clients')->group(function () {
    Route::get('/', 'ClientsController@clients');
    Route::get('/{client_id}', 'ClientsController@client');
    Route::get('/{client_id}/recommendations', 'ClientsController@clientRecommendations');
    Route::post('/{client_id}/recommendation', 'ClientsController@addRecommendation');
});
Route::get('/requests', 'RequestsController@requests');
Route::get('/requests/{request_id}', 'RequestsController@request');
Route::update('/requests/{request_id}', 'RequestsController@update');
Route::put('/requests/{request_id}/update-status', 'RequestsController@updateStatus');

// Route::post('register', 'Auth\RegisterController@register');

Route::get('/category/{category}/professions', 'ProfessionsController@professions');
Route::get('/cities', 'CitiesController@cities');
//Get /category/{category_id}/professions ()(professions)
