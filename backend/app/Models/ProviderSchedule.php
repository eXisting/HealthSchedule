<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

/**
 * Class ProviderSchedule
 *
 * Properties
 * @property integer $id
 * @property integer $provider_id
 * @property integer $week_day
 * @property Carbon $start_time
 * @property Carbon $end_time
 * @property boolean $working
 *
 * Relationships
 * @property User $provider
 */
class ProviderSchedule extends Model
{
    //region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'provider_id', 'week_day', 'start_time', 'end_time', 'working',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'provider_id' => 'integer',
        'week_day' => 'integer',
        'start_time' => 'time',
        'end_time' => 'time',
        'working' => 'boolean',
    ];

    //endregion

    //region Methods

    //endregion

    //region Relationships

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function provider()
    {
        return $this->hasOne(User::class, 'id', 'provider_id');
    }

    //endregion
    public static function availableDates($cityId, $serviceId)
    {
        //select provider_schedules.* from provider_schedules
        //join users on users.id = provider_schedules.provider_id
        //join provider_services on users.id = provider_services.provider_id
        //where users.city_id = 1
        //and provider_services.service_id = 29
        //and provider_schedules.working = 1
        // $schedules = DB::table('provider_schedules')
        //     ->select('provider_schedules.*', 'provider_services.interval')
        //     ->leftJoin('users', 'provider_schedules.provider_id', '=', 'users.id')
        //     ->leftJoin('provider_services', 'provider_services.provider_id', '=', 'users.id')
        //     ->where('users.city_id', $cityId)
        //     ->where('provider_schedules.working', 1)
        //     ->where('provider_services.service_id', $serviceId)
        //     ->get();
        // return $schedules;

        // SELECT *, (time_to_sec(end_time)-time_to_sec(start_time))/time_to_sec(provider_services.interval) as possible_visits from provider_services
        // LEFT JOIN users on users.id = provider_services.provider_id left JOIN provider_schedules on provider_schedules.provider_id = provider_services.provider_id
        // left JOIN (
        //SELECT provider_service_id,count(provider_service_id) as inputs from requests where request_at BETWEEN '2019-01-01' and '2019-01-31' GROUP by provider_service_id
        //) as qqq on qqq.provider_service_id = provider_services.id
        // where provider_services.service_id = 29 and users.city_id = 1
        // HAVING qqq.inputs < possible_visits
        $from = new Carbon('first day of this month');
        $to = new Carbon('last day of this month');
        $requests = DB::table('requests')
            ->select('provider_service_id', DB::raw('count(provider_service_id) as number_of_requests'))
            ->whereBetween('request_at', [
                $from->format('Y-m-d'),
                $to->format('Y-m-d')
                ])
            ->groupBy('provider_service_id');

        $res = DB::table('provider_services')
            ->select(DB::raw('number_of_requests.number_of_requests,
            provider_schedules.week_day,
            provider_services.service_id,
            provider_services.provider_id,
            (time_to_sec(end_time) - time_to_sec(start_time)) / time_to_sec(provider_services.interval) as number_of_possible_requests
            '))
            ->leftJoin('users', 'users.id', '=', 'provider_services.provider_id')
            ->leftJoin('provider_schedules', 'provider_schedules.provider_id', '=', 'provider_services.provider_id')
            ->leftJoinSub($requests, 'number_of_requests', function ($join) {
                $join->on('number_of_requests.provider_service_id', '=', 'provider_services.id');
            })
            // ->where('provider_services.service_id', $serviceId)
            // ->where('users.city_id', $cityId)
            ->having('number_of_requests.number_of_requests', '<', DB::raw('number_of_possible_requests'));

        dd($res->get());
    }
}
