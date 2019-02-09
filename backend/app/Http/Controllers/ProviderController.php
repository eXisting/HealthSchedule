<?php

namespace App\Http\Controllers;

use App\Http\Requests\Provider\GetProvidersByIdsRequest;
use App\Models\User;
use App\Models\UserRole;
use Illuminate\Http\Request;
use App\Models\ProviderSchedule;
use DB;
use Illuminate\Support\Collection;
use Gate;

/**
 * Class ProviderController
 *
 * Properties
 * @property User $authUser
 */
class ProviderController extends AuthUserController
{
    /**
     * ProviderController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    public function availableDates(Request $request)
    {
        $cityId = $request->post('city_id');
        $serviceId = $request->post('service_id');
        $workingDates = ProviderSchedule::availableDates($cityId, $serviceId);
        return response()->json($workingDates);
    }

    /**
     * @param Request $request
     * @return Collection
     */
    public function users(Request $request)
    {
        /** @var Collection $users */
        $users = DB::table('users AS user')
            ->select(
                'users.id as id',
                'users.first_name as first_name',
                'users.last_name as last_name',
                'requests.id AS request_id',
                'provider_services.id AS provider_service_id'
            )
            ->join('provider_services', 'provider_services.provider_id', '=', 'user.id')
            ->leftJoin('requests', 'requests.provider_service_id', '=', 'provider_services.id')
            ->join('users', 'users.id', '=', 'requests.user_id')
            ->where('user.id', $this->authUser->id)
            ->where(function ($query) use ($request) {
                $query->where('users.first_name', 'like', '%' . $request->name . '%')
                    ->orWhere('users.last_name', 'like', '%' . $request->name . '%');
            })
            ->get();

        return $users;
    }

    /**
     * @param User $user
     * @return \Illuminate\Http\JsonResponse
     */
    public function user(User $user)
    {
        if (Gate::denies('provider-get-user', $user->id)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($user);
    }

    /**
     * @param GetProvidersByIdsRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getByIds(GetProvidersByIdsRequest $request)
    {
        $providers = User::query()
            ->where('user_role_id', UserRole::PROVIDER)
            ->whereIn('id', $request->ids)
            ->get();

        return response()->json($providers);
    }

    /**
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getDateTimes(Request $request)
    {
        $city_id = $request->city_id;
        $service_id = $request->service_id;
        $provider_service_id = $request->provider_service_id;
        $from = $request->get('date_from') ? \Carbon\Carbon::parse($request->date_from) : \Carbon\Carbon::now();
        $to = $request->get('date_to') ? \Carbon\Carbon::parse($request->date_to) : new \Carbon\Carbon('last day of this month');

        $arrDateWithDayOfWeek = collect([]);

        for ($weekDay=$from->dayOfWeek, $date=$from->day; $date<=$from->daysInMonth; $weekDay++, $date++) {

            $arrDateWithDayOfWeek->push(['week_day' => $weekDay, 'date' => \Carbon\Carbon::create($from->year, $from->month, $date)->toDateString() ]);

            if($weekDay == 6 && $date<=$from->daysInMonth) {
                $weekDay=-1;
            }
        }

//        $providerServices = (new \App\Models\ProviderService())->query()
//            ->whereHas('provider', function ($query) use ($city_id) {
//                /** @var \Illuminate\Database\Query\Builder $query */
//                $query->where('city_id', $city_id);
//            })
//            ->where('service_id', $service_id)
//            ->with([
//                'requests' => function ($query) use ($from, $to) {
//                    /** @var \Illuminate\Database\Query\Builder $query */
//                    $query->where(function ($query) use ($from, $to) {
//                        $query->where('status', null)->orWhere('status', 1);
//                    })->whereBetween('request_at', [$from, $to]);
//                },
//                'provider.providerSchedules' => function($query) {
//                    $query->where('working', 1);
//                },
//                'provider.providerExceptionSchedules' => function($query) use ($from, $to) {
//                    $query->whereBetween('exception_at', array($from->toDateString(), $to->toDateString()))
//                        ->where('working', 1);
//                }])
//            ->get();

        $query = (new \App\Models\ProviderService())->query();

        if($city_id) {
            $query->whereHas('provider', function ($query) use ($city_id) {
                /** @var \Illuminate\Database\Query\Builder $query */
                $query->where('city_id', $city_id);
            });
        }

        if($service_id) {
            $query->where('service_id', $service_id);
        }

        if($provider_service_id) {
            $query->where('id', $provider_service_id);
        }

        $providerServices = $query->with([
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
            }])->get();

        $schedulesArr = collect([]);

        $providerServices->each(function ($providerService) use ($arrDateWithDayOfWeek, &$schedulesArr) {
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

            $schedules = $providerService->schedules;



            $schedules = $schedules->map(function ($data) use ($providerService) {
                $data['times_by_interval'] = $data['times_by_interval']->map(function ($time, $key) use ($providerService) {
                    return ['time' => $time, 'provider_ids' => collect([$providerService->provider_id])];
                });

                return $data;
            });

            $schedulesArr = $schedulesArr->merge($schedules);
        });

        $schedulesArr = $schedulesArr->groupBy('date')->map(function ($items, $date) {
            $times = collect([]);

            $items->each(function ($data) use (&$times) {
                $times = $times->merge($data['times_by_interval']);
            });

            $times = $times->groupBy('time')->map(function ($time) {

                $provider_ids = collect([]);

                $time->each(function ($item) use (&$provider_ids) {
                    $provider_ids = $provider_ids->merge($item['provider_ids']);
                });

                return $provider_ids;
            });

            if($times->count()) {
                return ['date' => $date, 'times' => $times];
            }
        })->filter(function ($item, $date) {

            return $item != null;
        });

        return response()->json($schedulesArr);
    }
}
