<?php

namespace App\Http\Controllers;

use App\Http\Requests\User\UpdateUserPasswordRequest;
use App\Http\Requests\User\UpdateUserInfoRequest;
use App\Models\User;
use Hash;

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

    /**
     * @param UpdateUserInfoRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(UpdateUserInfoRequest $request)
    {
        $result = $this->authUser->update($request->all());

        return response()->json(['success' => $result]);
    }

    /**
     * @param UpdateUserPasswordRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function updatePassword(UpdateUserPasswordRequest $request)
    {
        $result = false;

        if(Hash::check($request->old_password, $this->authUser->password)) {
            if(Hash::check($request->new_password, $this->authUser->password)) {
                $result = true;
            } else {
                $result = $this->authUser->update(['password' => bcrypt($request->new_password)]);
            }
        }

        return response()->json(['success' => $result]);
    }
}
