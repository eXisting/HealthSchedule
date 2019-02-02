<?php

namespace App\Http\Controllers;

use App\Http\Requests\Recommendation\RecommendationRequest;
use App\Models\Recommendation;
use App\Models\User;
use App\Repositories\RecommendationRepository;
use Gate;

/**
 * Class ProviderRecommendationController
 *
 * Properties
 * @property User $authUser
 * @property RecommendationRepository $recommendation
 */
class ProviderRecommendationController extends RecommendationController
{
    /**
     * ProviderRecommendationController constructor.
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
        $recommendations = $this->authUser->providerRecommendations()
            ->get();

        return response()->json($recommendations);
    }


    /**
     * @param integer $recommendation_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function recommendation($recommendation_id)
    {
        $recommendation = $this->recommendation->getRecommendationWithUser($recommendation_id);

        if(!$recommendation) {
            return response()->json(['message' => 'Recommendation not found']);
        }

        if(Gate::denies('provider-get-recommendation', $recommendation)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($recommendation);
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
