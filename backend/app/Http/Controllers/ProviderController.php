<?php

namespace App\Http\Controllers;

class ProviderController extends Controller
{
    /**
     * Return provider object by jwt
     *
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function getByToken()
    {
        return auth('api')->user();
    }

}
