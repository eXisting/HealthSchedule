<?php

namespace App\Http\Controllers\Auth;

use App\Http\Requests\Auth\UserRegisterRequest;
use App\Models\User;
use App\Models\UserRole;
use JWTAuth;
use App\Models\UserImage;
use App\Helpers\FileManager;

class UserRegisterController extends RegisterController
{
    public function registerUser(UserRegisterRequest $request)
    {
        $user = User::create([
            'user_role_id' => UserRole::CLIENT,
            'city_id' => $request->city_id,
            'email' => $request->email,
            'phone' => $request->phone,
            'confirmed_status' => 1,
            'password' => bcrypt($request->password),
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'birthday_at' => $request->birthday,
        ]);

        if($request->hasFile('photo')) {
            $image_path = FileManager::saveImage( $request->file('photo'), 'user-photo' );

            UserImage::create([
                'user_id' => $user->id,
                'image_path' => $image_path
            ]);
        }

        $token = JWTAuth::fromUser($user);

        return response()->json(compact('token'));

    }
}
