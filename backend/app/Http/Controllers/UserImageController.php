<?php

namespace App\Http\Controllers;

use App\Helpers\FileManager;
use App\Http\Requests\User\UpdateUserImageRequest;
use App\Models\User;

/**
 * Class UserImageController
 *
 * Properties
 * @property User $authUser
 */
class UserImageController extends AuthUserController
{

    /**
     * UserImageController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @param UpdateUserImageRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(UpdateUserImageRequest $request)
    {
        $image = $this->authUser->image;

        $image_path = FileManager::saveImage( $request->file('photo'), 'user-photo' );

        if(!$image_path) {
            return response()->json(['message' => 'Image did not save', 'success' => false]);
        }

        if($image) {
            FileManager::deleteFile($image->image_path);

            $result = $image->update(['image_path' => $image_path]);
        } else {
            $imageFromDb = $this->authUser->image()->create(['image_path' => $image_path]);

            if($imageFromDb) {
                $result = true;
            } else {
                $result = false;
            }
        }

        return response()->json(['success' => $result]);
    }

}
