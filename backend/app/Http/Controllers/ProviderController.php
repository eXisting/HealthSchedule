<?php

namespace App\Http\Controllers;

use App\Models\User;
use DB;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Gate;

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

    /**
     * @param Request $request
     * @return Collection
     */
    public function users(Request $request)
    {
        /** @var Collection $users */
        $users = DB::table('users AS user')
            ->select(
                'users.id as id',
                'users.first_name as first_name',
                'users.last_name as last_name',
                'requests.id AS request_id',
                'provider_services.id AS provider_service_id'
            )
            ->join('provider_services', 'provider_services.provider_id', '=', 'user.id')
            ->leftJoin('requests', 'requests.provider_service_id', '=', 'provider_services.id')
            ->join('users', 'users.id', '=', 'requests.user_id')
            ->where('user.id', $this->authUser->id)
            ->where(function ($query) use ($request) {
                $query->where('users.first_name', 'like', '%' . $request->name . '%')
                    ->orWhere('users.last_name', 'like', '%' . $request->name . '%');
            })
            ->get();

        return $users;
    }

    /**
     * @param User $user
     * @return \Illuminate\Http\JsonResponse
     */
    public function user(User $user)
    {
        if(Gate::denies('provider-get-user', $user->id)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json($user);
    }
}
