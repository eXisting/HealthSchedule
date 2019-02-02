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
class UserRecommendationController extends RecommendationController
{

    /**
     * UserRecommendationController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function recommendations()
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
            return response(['message' => 'Recommendation not found'], 404);
        }

        if(Gate::denies('user-get-recommendation', $recommendation)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($recommendation);
    }
}
