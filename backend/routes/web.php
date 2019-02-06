<?php

//use DB;
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

      \Illuminate\Support\Facades\DB::connection()->enableQueryLog();
      $city_id = $request->city_id;
      $service_id = $request->service_id;
      $from = \Carbon\Carbon::now();
      $to = new \Carbon\Carbon('last day of this month');
//      dd($from->daysInMonth-$from->day);
//      $coll = collect([]);
//        dd(\Carbon\Carbon::create(2019,2, 03)->dayOfWeek);
//      for ($i=$from->dayOfWeek, $j=1; $j<=$from->daysInMonth-$from->day; $i++) {
//          $j++;
//          if($i=6 && $j<$from->daysInMonth-$from->day) {
//              $i=0;
//          }
//          $coll->push($i);
//      }
      dd(\App\Models\User::query()->find(1));
        dd(\Carbon\Carbon::create(1998, 01,19)->age);
//      dd($from->daysInMonth ,$from->daysInMonth-$from->day, $coll);

      $providerServices = (new \App\Models\ProviderService())->query()
          ->whereHas('provider', function ($query) use ($city_id) {
              /** @var \Illuminate\Database\Query\Builder $query */
              $query->where('city_id', $city_id);
          })
          ->where('service_id', $service_id)
          ->with([
              'requests' => function ($query) use ($from, $to) {
                  /** @var \Illuminate\Database\Query\Builder $query */
                  $query->whereBetween('request_at', array($from, $to));
              },
              'provider.providerSchedules',
              'provider.providerExceptionSchedules' => function($query) use ($from, $to) {
                  $query->whereBetween('exception_at', array($from->toDateString(), $to->toDateString()));
              }])
          ->get();
      dd($providerServices);
//      $queries = \Illuminate\Support\Facades\DB::getQueryLog();
//      dd($queries);
[
    'date' => '2019-01-01',
    'start_time' => '08:00',
    'end_time' => '12:00',
    'interval' => '01:00',
    'times_by_interval' => [
        '08:00','09:00','10:00','11:00'
    ]
];

  });
