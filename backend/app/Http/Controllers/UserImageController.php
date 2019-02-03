<?php

namespace App\Http\Controllers;

use App\Helpers\FileManager;
use App\Http\Requests\User\UpdateUserImageRequest;
use App\Models\User;
use App\Models\UserImage;
use App\Repositories\UserImageRepository;

/**
 * Class UserImageController
 *
 * Properties
 * @property User $authUser
 */
class UserImageController extends AuthUserController
{
    /**
     * @var UserImageRepository
     */
    public $image;

    /**
     * UserImageController constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->image = new UserImageRepository();
    }

    /**
     * @param UpdateUserImageRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(UpdateUserImageRequest $request)
    {
        $image = $this->authUser->image;

        if($image) {
            FileManager::deleteFile($image->image_path);
            try {
                $image->delete();
            } catch (\Exception $e) {
                return response()->json(['success' => false,'message' => $e->getMessage()]);
            }
        }

        if($request->hasFile('photo')) {
            /** @var UserImage $newImage */
            $newImage = $this->image->save($request->file('photo'), 'user_photo', $this->authUser->id);

            return response()->json(['success' => true, 'image_path' => $newImage->image_path]);
        } else {
            return response()->json(['success' => false, 'message' => 'Has not image in request body']);
        }

    }

}
