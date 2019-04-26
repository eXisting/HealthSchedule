<?php

namespace App\Http\Controllers\Auth\Register;

use App\Http\Interfaces\RegisterInterface;
use App\Http\Requests\Auth\ProviderRegisterRequest;
use App\Models\UserRole;
use App\Repositories\ProviderRepository;
use App\Repositories\ProviderVerifyRepository;
use Carbon\Carbon;
use JWTAuth;

class ProviderRegisterController extends RegisterController implements RegisterInterface
{
    /**
     * @var ProviderRegisterRequest
     */
    public $request;

    /**
     * @var ProviderRepository
     */
    public $provider;

    /**
     * @var ProviderVerifyRepository
     */
    // public $verify;

    /**
     * ProviderRegisterController constructor.
     * @param ProviderRegisterRequest $request
     */
    public function __construct(ProviderRegisterRequest $request)
    {
        $this->request = $request;
        $this->provider = new ProviderRepository();
        // $this->verify = new ProviderVerifyRepository();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function register()
    {
        $providerData = array_merge($this->request->all(), [
            'user_role_id' => UserRole::PROVIDER,
            'confirmed_status' => 0,
            'password' => bcrypt($this->request->password),
            'birthday_at' => Carbon::parse($this->request->birthday)->toDateTimeString()
        ]);

        $provider = $this->provider->model->create($providerData);

        if (!$provider) {
            return response()->json(['message' => 'Provider did not create']);
        }

        // if($this->request->hasFile('verify')) {
        //     collect($this->request->file('verifies'))->each(function ($verify) use ($provider) {
        //         $this->verify->save($verify, 'provider_verify', $provider->id);
        //     });
        // }

        $success = true;

        $token = JWTAuth::fromUser($provider);

        return response()->json(compact('success', 'token'));
    }
}
