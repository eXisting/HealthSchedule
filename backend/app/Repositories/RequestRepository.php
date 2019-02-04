<?php

namespace App\Repositories;

use App\Models\Request;

/**
 * Class RequestRepository
 *
 * Properties
 * @property Request $model;
 */
class RequestRepository
{
    /**
     * @var Request
     */
    public $model;

    /**
     * RequestRepository constructor.
     */
    public function __construct()
    {
        $this->model = new Request();
    }

    /**
     * @param integer $request_id
     * @return \Illuminate\Database\Eloquent\Builder|\Illuminate\Database\Eloquent\Builder[]|\Illuminate\Database\Eloquent\Collection|\Illuminate\Database\Eloquent\Model|null
     */
    public function getRequestWithProviderService($request_id)
    {
        return $this->model->query()->with('providerService.address', 'providerService.provider', 'providerService.service')->find($request_id);
    }

    /**
     * @param integer $request_id
     * @return \Illuminate\Database\Eloquent\Builder|\Illuminate\Database\Eloquent\Builder[]|\Illuminate\Database\Eloquent\Collection|\Illuminate\Database\Eloquent\Model|null
     */
    public function getRequestWithUser($request_id)
    {
        return $this->model->query()->with('user.address','user.city', 'providerService.address', 'providerService.service')->find($request_id);
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
            return response()->json(['message' => 'Request did not save']);
        }

        return $result;
    }
}