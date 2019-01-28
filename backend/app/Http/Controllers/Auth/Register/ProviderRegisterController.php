<?php

namespace App\Http\Controllers\Auth\Register;

use App\Http\Interfaces\RegisterInterface;
use App\Http\Requests\Auth\ProviderRegisterRequest;
use App\Models\UserRole;
use App\Repositories\AddressRepository;
use App\Repositories\ProviderRepository;
use App\Repositories\ProviderVerifyRepository;
use App\Repositories\UserImageRepository;
use Carbon\Carbon;
use Validator;
use JWTAuth;

class ProviderRegisterController extends RegisterController implements RegisterInterface
{
    /**
     * @var ProviderRegisterRequest
     */
    public $request;

    /**
     * @var AddressRepository
     */
    public $address;

    /**
     * @var ProviderRepository
     */
    public $provider;

    /**
     * @var UserImageRepository
     */
    public $image;

    /**
     * @var ProviderVerifyRepository
     */
    public $verify;



    /**
     * ProviderRegisterController constructor.
     * @param ProviderRegisterRequest $request
     */
    public function __construct(ProviderRegisterRequest $request)
    {
        $this->request = $request;
        $this->address = new AddressRepository();
        $this->provider = new ProviderRepository();
        $this->image = new UserImageRepository();
        $this->verify = new ProviderVerifyRepository();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function register()
    {
        $address = $this->address->findOrCreate($this->request->address);

        $providerData = array_merge($this->request->all(), [
            'user_role_id' => UserRole::PROVIDER,
            'address_id' => $address->id,
            'confirmed_status' => 0,
            'password' => bcrypt($this->request->password),
            'birthday_at' => Carbon::parse($this->request->birthday)->toDateTimeString()
        ]);

        $provider = $this->provider->model->create($providerData);

        if(!$provider) {
            return response()->json(['message' => 'Provider did not create']);
        }

        if(count($this->request->professions)) {
            collect($this->request->professions)->each(function ($profession_id) use ($provider) {
                $this->provider->saveProfession($provider->id, $profession_id);
            });
        }

        if($this->request->hasFile('photo')) {
            $this->image->save($this->request->file('photo'), 'user-photo', $provider->id);
        }

        if($this->request->hasFile('verifies')) {
            collect($this->request->file('verifies'))->each(function ($verify) use ($provider) {
                $this->verify->save($verify, 'provider_verify', $provider->id);
            });
        }

        $success = true;

        return response()->json(compact('success'));
    }
}
