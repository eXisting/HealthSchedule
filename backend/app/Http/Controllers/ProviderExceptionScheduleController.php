<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateProviderProfessionRequest;
use App\Http\Requests\Provider\Address\UpdateProviderAddressRequest;
use App\Http\Requests\Provider\ProviderExceptionSchedule\CreateProviderExceptionScheduleRequest;
use App\Http\Requests\Provider\ProviderExceptionSchedule\UpdateProviderExceptionScheduleRequest;
use App\Models\ProviderExceptionSchedule;
use App\Models\ProviderProfession;
use App\Models\User;
use Gate;

/**
 * Class ProviderExceptionScheduleController
 *
 * Properties
 * @property User $authUser
 */
class ProviderExceptionScheduleController extends AuthUserController
{

    /**
     * ProviderExceptionScheduleController constructor.
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
        return response()->json($this->authUser->providerExceptionSchedules()->get());
    }

    /**
     * @param CreateProviderExceptionScheduleRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function create(CreateProviderExceptionScheduleRequest $request)
    {
        $data = array_merge($request->all(), ['provider_id' => $this->authUser->id]);

        $result = $this->authUser->providerExceptionSchedules()->create($data);

        if($result) {
            return response()->json(['success' => true]);
        }

        return response()->json(['success' => false]);
    }

    /**
     * @param ProviderExceptionSchedule $exceptionSchedule
     * @param UpdateProviderExceptionScheduleRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(ProviderExceptionSchedule $exceptionSchedule, UpdateProviderExceptionScheduleRequest $request)
    {
        if(Gate::denies('provider-update-exception-schedule', $exceptionSchedule)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json(['success' => $exceptionSchedule->update($request->all())]);
    }

    /**
     * @param ProviderExceptionSchedule $exceptionSchedule
     * @return \Illuminate\Http\JsonResponse
     */
    public function delete(ProviderExceptionSchedule $exceptionSchedule)
    {
        if(Gate::denies('provider-delete-exception-schedule', $exceptionSchedule)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        try {
            $exceptionSchedule->delete();
        } catch (\Exception $e) {
            return response()->json(['success' => false,'message' => $e->getMessage()]);
        }

        return response()->json(['success' => true]);
    }
}
