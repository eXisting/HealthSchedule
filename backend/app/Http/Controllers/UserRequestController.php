<?php

namespace App\Http\Controllers;

use App\Http\Requests\Recommendation\RecommendationRequest;
use App\Http\Requests\User\Request\CreateUserRequestRequest;
use App\Models\ProviderService;
use App\Models\Request;
use App\Models\User;
use App\Repositories\RequestRepository;
use Gate;

/**
 * Class UserRequestController
 *
 * Properties
 * @property User $authUser
 * @property RequestRepository $request
 */
class UserRequestController extends RequestController
{
    /**
     * UserRequestController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function requests()
    {
        /** @var Request $requests */
        $requests = $this->authUser->userRequests()
            ->with('providerService.address', 'providerService.provider', 'providerService.service')
            ->get();

        return response()->json($requests);
    }

    /**
     * @param integer $request_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function request($request_id)
    {
        $request = $this->request->getRequestWithProviderService($request_id);

        if(!$request) {
            return response(['message' => 'Request not found'], 404);
        }

        if(Gate::denies('user-get-request', $request)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($request);
    }

    /**
     * @param CreateUserRequestRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(CreateUserRequestRequest $request)
    {
        $providerService = ProviderService::query()
            ->where('provider_id', $request->provider_id)
            ->where('service_id', $request->service_id)
            ->first();

        if(!$providerService) {
            return response(['success' => false], 404);
        }

        $this->request->create($this->authUser->id, $request->all());

        return response()->json(['success' => true]);
    }

    public function update()
    {
        //
    }

    public function updateRate()
    {
        //
    }

}
