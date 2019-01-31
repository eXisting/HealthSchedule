<?php

namespace App\Http\Controllers;

use App\Models\User;

/**
 * Class UserController
 *
 * Properties
 * @property User $authUser
 */
class UserController extends AuthUserController
{

    /**
     * UserController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }


}
