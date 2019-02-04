<?php

namespace App\Http\Controllers\Auth\Register;

use App\Http\Interfaces\RegisterInterface;
use App\Http\Requests\Auth\UserRegisterRequest;
use App\Models\UserRole;
use App\Repositories\UserImageRepository;
use App\Repositories\UserRepository;
use Carbon\Carbon;
use JWTAuth;

class UserRegisterController extends RegisterController implements RegisterInterface
{
    /**
     * @var UserRegisterRequest
     */
    public $request;

    /**
     * @var UserRepository
     */
    public $user;

    /**
     * @var UserImageRepository
     */
    public $image;


    /**
     * ProviderRegisterController constructor.
     * @param UserRegisterRequest $request
     */
    public function __construct(UserRegisterRequest $request)
    {
        $this->request = $request;
        $this->user = new UserRepository();
        $this->image = new UserImageRepository();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function register()
    {
        $userData = array_merge($this->request->all(), [
            'user_role_id' => UserRole::CLIENT,
            'confirmed_status' => 1,
            'password' => bcrypt($this->request->password),
            'birthday_at' => Carbon::parse($this->request->birthday)->toDateTimeString()
        ]);

        $user = $this->user->model->create($userData);

        if(!$user) {
            return response()->json(['message' => 'User did not create']);
        }

        if($this->request->hasFile('photo')) {
            $this->image->save($this->request->file('photo'), 'user_photo', $user->id);
        }

        $success = true;

        $token = JWTAuth::fromUser($user);

        return response()->json(compact('success', 'token'));
    }

}
