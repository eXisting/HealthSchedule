<?php

namespace App\Http\Controllers\Auth;

use App\Helpers\FileManager;
use App\Http\Requests\Auth\ProviderRegisterRequest;
use App\Models\Address;
use App\Models\ProviderProfession;
use App\Models\ProviderVerify;
use App\Models\UserImage;
use App\Models\UserRole;
use Validator;
use App\Models\User;
use JWTAuth;

class ProviderRegisterController extends RegisterController
{
    public function registerUser(ProviderRegisterRequest $request)
    {
        $address = Address::firstOrCreate(['address' => $request->address], ['address' => $request->address]);

        $provider = User::create([
            'user_role_id' => UserRole::PROVIDER,
            'address_id' => $address->id,
            'city_id' => $request->city_id,
            'email' => $request->email,
            'phone' => $request->phone,
            'confirmed_status' => 0,
            'password' => bcrypt($request->password),
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'birthday_at' => $request->birthday,
        ]);

        if(count($request->professions)) {
            collect($request->professions)->each(function ($profession_id) use ($provider) {
                ProviderProfession::create([
                    'profession_id' => $profession_id,
                    'provider_id' => $provider->id
                ]);
            });
        }

        if($request->hasFile('photo')) {
            $image_path = FileManager::saveImage( $request->file('photo'), 'user-photo' );

            UserImage::create([
                'user_id' => $provider->id,
                'image_path' => $image_path
            ]);
        }

        if($request->hasFile('verifies')) {
            collect($request->file('verifies'))->each(function ($verify) use ($provider) {
                $doc_path = FileManager::saveImage( $verify, 'provider_verify' );

                ProviderVerify::create([
                    'provider_id' => $provider->id,
                    'document_path' => $doc_path
                ]);
            });
        }

        $success = true;

        return response()->json(compact('success'));
    }
}
