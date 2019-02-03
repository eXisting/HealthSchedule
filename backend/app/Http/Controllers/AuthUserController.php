<?php

namespace App\Http\Controllers;

use App\Helpers\FileManager;
use App\Http\Requests\UpdateUserPasswordRequest;
use App\Http\Requests\User\UpdateUserImageRequest;
use App\Http\Requests\User\UpdateUserInfoRequest;
use App\Models\User;

/**
 * Class AuthUserController
 *
 * Properties
 * @property User $authUser
 */
class AuthUserController extends Controller
{
    /**
     * @var User
     */
    protected $authUser;

    /**
     * AuthUserController constructor.
     */
    public function __construct()
    {
        $this->authUser = auth('api')->user();
    }

    /**
     * Return auth user object by jwt
     *
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function get()
    {
        return $this->authUser->load('image', 'address', 'role', 'city');
    }

}
