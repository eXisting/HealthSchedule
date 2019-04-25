<?php

namespace App\Http\Controllers;

use App\Http\Requests\Provider\Service\CreateProviderServiceRequest;
use App\Http\Requests\Provider\Service\UpdateProviderServiceRequest;
use App\Models\ProviderService;
use App\Models\User;
use App\Repositories\AddressRepository;
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
        $addressRep = new AddressRepository();

        $address = $addressRep->findOrCreate($request->address);

        $data = array_merge($request->all(), ['address_id' => $address->id]);

        $result = $this->authUser->providerServices()->create($data);

        if ($result) {
            return response()->json(['success' => true]);
        }

        return response()->json(['success' => false]);
    }

    /**
     * @param ProviderService $providerService
     * @param UpdateProviderServiceRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(ProviderService $providerService, UpdateProviderServiceRequest $request)
    {
        if (Gate::denies('provider-update-service', $providerService)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        $addressRep = new AddressRepository();

        $address = $addressRep->findOrCreate($request->address);

        $data = array_merge($request->all(), ['address_id' => $address->id]);

        return response()->json(['success' => $providerService->update($data)]);
    }

    /**
     * @param ProviderService $providerService
     * @return \Illuminate\Http\JsonResponse
     */
    public function delete(ProviderService $providerService)
    {
        if (Gate::denies('provider-delete-service', $providerService)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        try {
            $providerService->delete();
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }

        return response()->json(['success' => true]);
    }
}
