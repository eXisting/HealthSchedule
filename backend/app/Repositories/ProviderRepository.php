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
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    public function saveProfession($provider_id, $data)
    {
        $result = (new ProviderProfession())->create(array_merge($data, ['provider_id' => $provider_id]));

        if(!$result) {
            return response()->json(['message' => 'User did not create']);
        }

        return $result;
    }

}