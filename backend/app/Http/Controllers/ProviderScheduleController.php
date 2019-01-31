<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateProviderProfessionRequest;
use App\Http\Requests\Provider\Address\UpdateProviderAddressRequest;
use App\Models\ProviderProfession;
use App\Models\User;
use Gate;

/**
 * Class ProviderScheduleController
 *
 * Properties
 * @property User $authUser
 */
class ProviderScheduleController extends AuthUserController
{

    /**
     * ProviderScheduleController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function all()
    {
        return response()->json($this->authUser->providerSchedules()->get());
    }

}
