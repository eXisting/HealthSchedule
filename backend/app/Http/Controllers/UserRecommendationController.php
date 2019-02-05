<?php

namespace App\Http\Controllers;

use App\Http\Requests\Recommendation\RecommendationRequest;
use App\Models\Recommendation;
use App\Models\User;
use App\Repositories\RecommendationRepository;
use Gate;
use Illuminate\Http\Request;

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
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function recommendations(Request $request)
    {
        $query = $this->authUser->userRecommendations();

        if($request->provider_id) {
            $query->where('provider_id', $request->provider_id);
        }

        /** @var Recommendation $recommendations */
        $recommendations = $query->get();

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
