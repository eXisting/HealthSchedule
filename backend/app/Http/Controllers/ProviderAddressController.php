<?php

namespace App\Http\Controllers;

use App\Http\Requests\Provider\Address\UpdateProviderAddressRequest;
use App\Models\Address;
use App\Models\User;

/**
 * Class ProviderAddressController
 *
 * Properties
 * @property User $authUser
 */
class ProviderAddressController extends AuthUserController
{

    /**
     * ProviderAddressController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @param UpdateProviderAddressRequest $request
     * @return \Illuminate\Http\JsonResponse
     * @throws \Exception
     */
    public function update(UpdateProviderAddressRequest $request)
    {
        $address = (new Address())->firstOrCreate(['address' => $request->address], ['address' => $request->address]);

        if($address->id != $this->authUser->address_id) {

            $oldAddress = $this->authUser->address;

            $this->authUser->update(['address_id' => $address->id]);

            if ($oldAddress && !($oldAddress->users()->exists() || $oldAddress->providerServices()->exists())) {
                try {
                    $oldAddress->delete();
                } catch (\Exception $e) {
                    return response()->json(['success' => false,'message' => $e->getMessage()]);
                }
            }
        }

        return response()->json(['success' => true]);
    }

}
