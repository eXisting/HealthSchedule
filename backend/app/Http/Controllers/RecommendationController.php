<?php

namespace App\Http\Controllers;

use App\Http\Requests\Recommendation\RecommendationRequest;
use App\Models\Recommendation;
use App\Models\User;
use App\Repositories\RecommendationRepository;
use Gate;

/**
 * Class UserRecommendationController
 *
 * Properties
 * @property User $authUser
 * @property RecommendationRepository $recommendation
 */
class RecommendationController extends AuthUserController
{
    /**
     * @var RecommendationRepository
     */
    private $recommendation;

    /**
     * UserRecommendationController constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->recommendation = new RecommendationRepository();
    }


    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function providerRecommendations()
    {
        /** @var Recommendation $recommendations */
        $recommendations = $this->authUser->providerRecommendations()
            ->get();

        return response()->json($recommendations);
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function userRecommendations()
    {
        /** @var Recommendation $recommendations */
        $recommendations = $this->authUser->userRecommendations()
            ->where('is_active', 1)
            ->get();

        return response()->json($recommendations);
    }

    /**
     * @param integer $recommendation_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function recommendation($recommendation_id)
    {
        $recommendation = $this->recommendation->getRecommendationWithProvider($recommendation_id);

        if(!$recommendation) {
            return response()->json(['message' => 'Recommendation not found']);
        }

        if(Gate::denies('user-get-recommendation', $recommendation)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($recommendation);
    }

    /**
     * @param integer $recommendation_id
     * @param string $status
     * @return \Illuminate\Http\JsonResponse
     */
    public function changeStatus($recommendation_id, $status)
    {
        if($recommendation_id) {
            $recommendation = $this->recommendation->model->query()->find($recommendation_id);

            if(!$recommendation) {
                return response()->json(['message' => 'Recommendation not found']);
            }
        } else {
            return response()->json(['message' => '{Recommendation_id} parameter is missing']);
        }

        if(Gate::denies('user-update-recommendation', $recommendation)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        if($status == 'active') {
            $recommendation->update([ 'is_active' => 1 ]);
        } elseif ($status == 'inactive') {
            $recommendation->update([ 'is_active' => 0 ]);
        } else {
            return response()->json(['message' => ' {Status} parameter is missing or bad']);
        }

        return response()->json(['success' => true]);
    }

    /**
     * @param RecommendationRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(RecommendationRequest $request)
    {
        if(Gate::denies('provider-create-recommendation', $request->user_id)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        $this->recommendation->create($this->authUser->id, $request->all());

        return response()->json(['success' => true]);

    }


}
