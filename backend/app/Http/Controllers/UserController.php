<?php

namespace App\Http\Controllers;

use App\Models\User;

/**
 * Class UserController
 *
 * Properties
 * @property User $user
 */
class UserController extends Controller
{
    /**
     * @var User
     */
    private $user;

    /**
     * UserController constructor.
     */
    public function __construct()
    {
        $this->user = auth('api')->user();
    }

    /**
     * Return user object by jwt
     *
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function getByToken()
    {
        return $this->user->load('image');
    }

}
