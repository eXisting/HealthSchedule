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
        $requests = $this->authUser->providerRequests()
            ->with(
                'providerService.address',
                'providerService.service'
            )->get();
        
        $result = [];
        foreach($requests as $request) {
            $requestUser = $this->authUser->getUser($request->user_id);
            $request->providerService["user"] = $requestUser;
            $requestUser["role"] = $this->authUser->getRole($requestUser->user_role_id);
            $requestUser["city"] = $this->authUser->getCity($requestUser->city_id);
            unset($requestUser["user_role_id"]);
            unset($requestUser["role_id"]);
            
            $result[] = $request;
        }
        
        return response()->json($result);
    }


    /**
     * @param integer $request_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function request($request_id)
    {
        $request = $this->request->getRequestWithProviderService($request_id);

        if(!$request) {
            return response()->json(['message' => 'Request not found']);
        }

        if(Gate::denies('provider-get-request', $request)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($request);
    }


}
