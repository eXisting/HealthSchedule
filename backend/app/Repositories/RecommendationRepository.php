<?php

namespace App\Repositories;

use App\Models\Recommendation;

/**
 * Class RecommendationRepository
 *
 * Properties
 * @property Recommendation $model;
 */
class RecommendationRepository
{
    /**
     * @var Recommendation
     */
    public $model;

    /**
     * RecommendationRepository constructor.
     */
    public function __construct()
    {
        $this->model = new Recommendation();
    }

    /**
     * @param integer $recommendation_id
     * @return \Illuminate\Database\Eloquent\Builder|\Illuminate\Database\Eloquent\Builder[]|\Illuminate\Database\Eloquent\Collection|\Illuminate\Database\Eloquent\Model|null
     */
    public function getRecommendationWithProvider($recommendation_id)
    {
        return $this->model->query()->with('provider')->find($recommendation_id);
    }

    /**
     * @param integer $provider_id
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    public function create($provider_id, $data)
    {
        $result = $this->model->create(array_merge($data, [ 'provider_id' => $provider_id ]));

        if(!$result) {
            return response()->json(['message' => 'Recommendation did not save']);
        }

        return $result;
    }
}