<?php

namespace App\Http\Controllers;

use App\Models\User;

/**
 * Class ProviderController
 *
 * Properties
 * @property User $authUser
 */
class ProviderController extends AuthUserController
{

    /**
     * ProviderController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

}
