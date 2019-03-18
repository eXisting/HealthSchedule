<?php

namespace App\Http\Controllers;

use App\Http\Requests\Recommendation\RecommendationRequest;
use App\Models\Recommendation;
use App\Models\Request;
use App\Models\User;
use App\Repositories\RecommendationRepository;
use App\Repositories\RequestRepository;
use Gate;

/**
 * Class ProviderRequestController
 *
 * Properties
 * @property User $authUser
 * @property RequestRepository $request
 */
class ProviderRequestController extends RequestController
{
    /**
     * ProviderRequestController constructor.
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
        $requests = $this->authUser->providerRequests()->get();
        return response()->json($requests);
    }


    /**
     * @param integer $request_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function request($request_id)
    {
        $request = $this->request->getRequestWithUser($request_id);

        if(!$request) {
            return response()->json(['message' => 'Request not found']);
        }

        if(Gate::denies('provider-get-request', $request)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($request);
    }


}
