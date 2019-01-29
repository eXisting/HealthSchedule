<?php

namespace App\Http\Controllers;

use App\Models\User;

/**
 * Class ProviderController
 *
 * Properties
 * @property User $provider
 */
class ProviderController extends Controller
{
    /**
     * @var User
     */
    private $provider;

    /**
     * ProviderController constructor.
     */
    public function __construct()
    {
        $this->provider = auth('api')->user();
    }

    /**
     * Return provider object by jwt
     *
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function getByToken()
    {
        return $this->provider->load('image');
    }

}
