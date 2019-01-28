<?php

namespace App\Http\Controllers;

class UserController extends Controller
{
    /**
     * Return user object by jwt
     *
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function getByToken()
    {
        return auth('api')->user();
    }

}
