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

      $city_id = $request->city_id;
      $service_id = $request->service_id;
      $from = \Carbon\Carbon::now();
      $to = new \Carbon\Carbon('last day of this month');


      $arrDateWithDayOfWeek = collect([]);

      for ($weekDay=$from->dayOfWeek, $date=$from->day; $date<=$from->daysInMonth; $weekDay++, $date++) {

          $arrDateWithDayOfWeek->push(['week_day' => $weekDay, 'date' => \Carbon\Carbon::create($from->year, $from->month, $date)->toDateString() ]);

          if($weekDay == 6 && $date<=$from->daysInMonth) {
              $weekDay=-1;
          }
      }

      $providerServices = (new \App\Models\ProviderService())->query()
          ->whereHas('provider', function ($query) use ($city_id) {
              /** @var \Illuminate\Database\Query\Builder $query */
              $query->where('city_id', $city_id);
          })
          ->where('service_id', $service_id)
          ->with([
              'requests' => function ($query) use ($from, $to) {
                  /** @var \Illuminate\Database\Query\Builder $query */
                  $query->where(function ($query) use ($from, $to) {
                      $query->where('status', null)->orWhere('status', 1);
                  })->whereBetween('request_at', [$from, $to]);
              },
              'provider.providerSchedules' => function($query) {
                  $query->where('working', 1);
              },
              'provider.providerExceptionSchedules' => function($query) use ($from, $to) {
                  $query->whereBetween('exception_at', array($from->toDateString(), $to->toDateString()))
                      ->where('working', 1);
              }])
          ->get();

      $providerServices->each(function ($providerService) use ($arrDateWithDayOfWeek) {
          /** @var \App\Models\ProviderService $providerService */
          $providerService->schedules = collect([]);

          $arrDateWithDayOfWeek->each(function ($date) use (&$providerService) {
              $providerService->provider->providerSchedules->each(function ($schedule) use (&$providerService, $date) {
                  /** @var \App\Models\ProviderSchedule $schedule */
                  if ($date['week_day'] == $schedule->week_day) {
                      $providerService->schedules->push([
                          'date' => $date['date'],
                          'start_time' => $schedule->start_time,
                          'end_time' => $schedule->end_time
                      ]);
                  }
              });
          });

          $exceptionSchedules = $providerService->provider->providerExceptionSchedules;

          if(count($providerService->schedules) && count($exceptionSchedules)) {
              $providerService->schedules->each(function ($schedule) use (&$providerService, $exceptionSchedules) {
                  /**
                   * @var \Illuminate\Support\Collection $schedule
                   * @var \App\Models\ProviderService $providerService
                   */

                  $exceptionSchedules->each(function ($exceptionSchedule) use (&$providerService, $schedule) {
                      /** @var \App\Models\ProviderExceptionSchedule $exceptionSchedule */
                      if(\Carbon\Carbon::parse($exceptionSchedule->exception_at)->toDateString() == $schedule['date']) {
                          $schedule['start_time'] = $exceptionSchedule->start_time;
                          $schedule['end_time'] = $exceptionSchedule->end_time;
                      }

                      return $schedule;
                  });
              });
          }

          $startInterval = \Carbon\Carbon::createFromTime(0,0);

          $providerService->schedules = $providerService->schedules->map(function ($schedule) use (&$providerService, $startInterval) {

              $interval = $startInterval->diffInMinutes(\Carbon\Carbon::parse($providerService->interval));

              $current_time = \Carbon\Carbon::parse($schedule['start_time']);

              $end_time = \Carbon\Carbon::parse($schedule['end_time']);

              $schedule['times_by_interval'] = collect([]);

              while ($end_time->gte($current_time)) {
                  $schedule['times_by_interval']->push($current_time->toTimeString());
                  $current_time->addMinutes($interval);
              }

              return $schedule;
          });


          $providerService->requests->each(function ($req) use (&$providerService){
              /** @var \App\Models\Request $req */
              $reqDateTime = \Carbon\Carbon::parse($req->request_at);
              $reqDate = $reqDateTime->toDateString();
              $reqTime = $reqDateTime->toTimeString();
              $providerService->schedules = $providerService->schedules->map(function ($schedule) use ($reqDate, $reqTime) {
                  if($schedule['date'] == $reqDate) {
                      $schedule['times_by_interval'] = $schedule['times_by_interval']->filter(function ($value) use ($reqTime) {
                          return $value != $reqTime;
                      });
                  }

                  return $schedule;
              });
          });

      });

      dd($providerServices);

  });
