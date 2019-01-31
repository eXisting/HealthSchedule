<?php

namespace App\Http\Controllers;

use App\Helpers\FileManager;
use App\Http\Requests\Provider\Verify\CreateProviderVerifiesRequest;
use App\Models\ProviderVerify;
use App\Models\User;
use App\Repositories\ProviderVerifyRepository;

/**
 * Class ProviderAddressController
 *
 * Properties
 * @property User $authUser
 * @property ProviderVerifyRepository $verify
 */
class ProviderVerifyController extends AuthUserController
{

    /**
     * @var ProviderVerify
     */
    private $verify;

    /**
     * ProviderAddressController constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->verify = new ProviderVerifyRepository();
    }

    /**
     * @param CreateProviderVerifiesRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function create(CreateProviderVerifiesRequest $request)
    {
        if($request->hasFile('verifies')) {
            $verifies = collect([]);

            collect($request->file('verifies'))->each(function ($verify) use (&$verifies) {
                /** @var ProviderVerify $verifyObj */
                $verifyObj = $this->verify->save($verify, 'provider_verify', $this->authUser->id);

                $verifies->push($verifyObj);
            });

            return response()->json(['success' => true, 'verifies' => $verifies]);
        }

        return response()->json(['success' => false]);
    }

    /**
     * @param ProviderVerify $providerVerify
     * @return \Illuminate\Http\JsonResponse
     */
    public function delete(ProviderVerify $providerVerify)
    {
        if(Gate::denies('provider-delete-verify', $providerVerify)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        FileManager::deleteFile($providerVerify->document_path);

        try {
            $providerVerify->delete();
        } catch (\Exception $e) {
            return response()->json(['success' => false,'message' => $e->getMessage()]);
        }

        return response()->json(['success' => true]);
    }

}
