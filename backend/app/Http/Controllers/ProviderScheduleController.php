<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateProviderProfessionRequest;
use App\Http\Requests\Provider\Address\UpdateProviderAddressRequest;
use App\Http\Requests\Provider\ProviderSchedule\UpdateProviderSchedulesRequest;
use App\Models\ProviderProfession;
use App\Models\User;
use Gate;

/**
 * Class ProviderScheduleController
 *
 * Properties
 * @property User $authUser
 */
class ProviderScheduleController extends AuthUserController
{

    /**
     * ProviderScheduleController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function all()
    {
        return response()->json($this->authUser->providerSchedules()->get());
    }

    /**
     * @param UpdateProviderSchedulesRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(UpdateProviderSchedulesRequest $request)
    {
        if($this->authUser->providerSchedules()->exists()) {
            try {
                $this->authUser->providerSchedules()->delete();
            } catch (\Exception $e) {
                return response()->json(['success' => false,'message' => $e->getMessage()]);
            }
        }

        $providerId = ['provider_id' => $this->authUser->id];

        if(count($request->schedules)) {
            collect($request->schedules)->each(function ($schedules) use ($providerId) {
                $result = $this->authUser->providerSchedules()->create(array_merge($schedules, $providerId));

                if(!$result) {
                    return response()->json(['success' => false, 'message' => 'Schedule did not save']);
                }
            });
        }

        return response()->json(['success' => true]);
    }

}
