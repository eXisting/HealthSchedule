<?php

namespace App\Http\Controllers;

use App\Models\Recommendation;
use App\Models\User;
use App\Repositories\RecommendationRepository;
use Gate;

/**
 * Class UserRecommendationController
 *
 * Properties
 * @property User $user
 * @property RecommendationRepository $recommendation
 */
class UserRecommendationController extends Controller
{
    /**
     * @var User
     */
    private $user;

    /**
     * @var RecommendationRepository
     */
    private $recommendation;

    /**
     * UserRecommendationController constructor.
     */
    public function __construct()
    {
        $this->user = auth('api')->user();
        $this->recommendation = new RecommendationRepository();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function recommendations()
    {
        /** @var Recommendation $recommendations */
        $recommendations = $this->user->userRecommendations()
            ->where('is_active', 1)
            ->get();

        return response()->json($recommendations);
    }

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

}
