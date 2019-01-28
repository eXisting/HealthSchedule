<?php

namespace App\Repositories;

use App\Models\ProviderProfession;
use App\Models\User;

/**
 * Class ProviderRepository
 *
 * Properties
 * @property User $model;
 */
class ProviderRepository
{
    /**
     * @var User
     */
    public $model;

    /**
     * ProviderRepository constructor.
     */
    public function __construct()
    {
        $this->model = new User();
    }

    /**
     * @param $provider_id
     * @param $profession_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function saveProfession($provider_id, $profession_id)
    {
        $result = (new ProviderProfession())->create([
            'provider_id' => $provider_id,
            'profession_id' => $profession_id,
        ]);

        if(!$result) {
            return response()->json(['message' => 'User did not create']);
        }

        return $result;
    }

}