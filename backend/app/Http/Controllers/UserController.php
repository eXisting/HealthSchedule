<?php

namespace App\Http\Controllers;

use App\Http\Requests\User\UpdateUserPasswordRequest;
use App\Http\Requests\User\UpdateUserInfoRequest;
use App\Models\User;
use Hash;
use DB;
use Illuminate\Http\Request;

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
     * @return \Illuminate\Support\Collection
     */
    public function providers()
    {
        $providers = DB::table('users AS user')
            ->select(
                'professions.title AS profession_title',
                'users.id AS provider_id',
                'users.first_name as provider_first_name',
                'users.last_name as provider_last_name'
            )
            ->join('requests', 'requests.user_id', '=', 'user.id')
            ->join('provider_services', 'provider_services.id', '=', 'requests.provider_service_id')
            ->join('users', 'users.id', '=', 'provider_services.provider_id')
            ->join('services', 'services.id', '=', 'provider_services.service_id')
            ->join('professions', 'professions.id', '=', 'services.profession_id')
            ->where('user.id', $this->authUser->id)
            ->get();

        if (count($providers)) {
            $providers = collect($providers)->unique('provider_id')->groupBy('profession_title');
        }

        return $providers;
    }

    /**
     * @param User $provider
     * @return \Illuminate\Http\JsonResponse
     */
    public function provider(User $provider)
    {
        return response()->json($provider);
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

        if (Hash::check($request->old_password, $this->authUser->password)) {
            if (Hash::check($request->new_password, $this->authUser->password)) {
                $result = true;
            } else {
                $result = $this->authUser->update(['password' => bcrypt($request->new_password)]);
            }
        }

        return response()->json(['success' => $result]);
    }
}
