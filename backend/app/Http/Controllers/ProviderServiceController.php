<?php

namespace App\Http\Controllers;

use App\Http\Requests\Provider\Service\CreateProviderServiceRequest;
use App\Http\Requests\Provider\Service\UpdateProviderServiceRequest;
use App\Models\ProviderService;
use App\Models\User;
use Gate;

/**
 * Class ProviderProfessionController
 *
 * Properties
 * @property User $authUser
 */
class ProviderServiceController extends AuthUserController
{

    /**
     * ProviderProfessionController constructor.
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
        return response()->json($this->authUser->providerServices()->with('address', 'service')->get());
    }

    /**
     * @param CreateProviderServiceRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function create(CreateProviderServiceRequest $request)
    {
        $data = array_merge($request->all(), ['provider_id' => $this->authUser->id]);

        $result = $this->authUser->providerServices()->create($data);

        if($result) {
            return response()->json(['success' => true]);
        }

        return response()->json(['success' => false]);
    }

    /**
     * @param ProviderService $service
     * @param UpdateProviderServiceRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(ProviderService $service, UpdateProviderServiceRequest $request)
    {
        if(Gate::denies('provider-update-service', $service)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json(['success' => $service->update($request->all())]);
    }

    /**
     * @param ProviderService $service
     * @return \Illuminate\Http\JsonResponse
     */
    public function delete(ProviderService $service)
    {
        if(Gate::denies('provider-delete-service', $service)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        try {
            $service->delete();
        } catch (\Exception $e) {
            return response()->json(['success' => false,'message' => $e->getMessage()]);
        }

        return response()->json(['success' => true]);
    }

}
