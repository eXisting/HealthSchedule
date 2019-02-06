<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

  Route::get('/', function (\Illuminate\Http\Request $request) {
//      dd(\Carbon\Carbon::now()->month);
      dd(\Carbon\Carbon::now());
      $city_id = $request->city_id;
      $service_id = $request->service_id;

      (new ProviderService())->query()
          ->whereHas('provider', function ($query) use ($city_id) {
              /** @var Builder $query */
              $query->where('city_id', $query->city_id);
          })
          ->where('service_id', $service_id)

          ->get();
  });
