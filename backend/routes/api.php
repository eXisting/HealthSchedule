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

Route::post('login', 'Auth\LoginController@login');
Route::post('register/provider', 'Auth\ProviderRegisterController@registerUser');
Route::post('register/user', 'Auth\UserRegisterController@registerUser');

Route::get('/category/{category}/professions', 'ProfessionsController@professions');
Route::get('/cities', 'CityController@all');
//Get /category/{category_id}/professions ()(professions)
