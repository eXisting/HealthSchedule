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
        $address = $this->authUser->address;

        if($address) {
            dd($address->address == $request->address, !($address->users || $address->providerServices));
            if ($address->address == $request->address) {
                return response()->json(['success' => true]);
            }

            if (!($address->users || $address->providerServices)) {
                $address->delete();
            }
        }

        $address = (new Address())->firstOrCreate(['address' => $request->address], ['address' => $request->address]);

        $this->authUser->update(['address_id' => $address->id]);

        return response()->json(['success' => true]);
    }

}
