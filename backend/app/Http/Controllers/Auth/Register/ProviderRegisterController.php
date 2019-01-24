<?php

namespace App\Http\Controllers\Auth\Register;

use App\Http\Controllers\Auth\RegisterController;
use App\Http\Requests\Auth\ProviderRegisterRequest;

class ProviderRegisterController extends RegisterController
{
    protected function register(ProviderRegisterRequest $request)
    {

        $user = User::first();
        $token = JWTAuth::fromUser($user);

        return Response::json(compact('token'));
    }
}
