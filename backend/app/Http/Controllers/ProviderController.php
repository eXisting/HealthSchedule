<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Models\ProviderSchedule;

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
}
