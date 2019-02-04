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
    protected $recommendation;

    /**
     * UserRecommendationController constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->recommendation = new RecommendationRepository();
    }


    /**
     * @param Recommendation $recommendation
     * @param string $status
     * @return \Illuminate\Http\JsonResponse
     */
    public function changeStatus(Recommendation $recommendation, $status)
    {

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
