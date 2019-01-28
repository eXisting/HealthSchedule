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
}