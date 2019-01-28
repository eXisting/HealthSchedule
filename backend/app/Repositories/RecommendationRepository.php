<?php

namespace App\Repositories;

use App\Models\Recommendation;
use App\Models\User;

/**
 * Class RecommendationRepository
 *
 * Properties
 * @property Recommendation $model;
 */
class RecommendationRepository
{
    /**
     * @var User
     */
    public $model;

    /**
     * UserRepository constructor.
     */
    public function __construct()
    {
        $this->model = new Recommendation();
    }

    /**
     * @param $id
     * @return \Illuminate\Database\Eloquent\Builder|\Illuminate\Database\Eloquent\Builder[]|\Illuminate\Database\Eloquent\Collection|\Illuminate\Database\Eloquent\Model|null
     */
    public function getRecommendationWithProvider($id)
    {
        return $this->model->query()->with('provider')->find($id);
    }
}