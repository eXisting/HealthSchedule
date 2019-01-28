<?php

namespace App\Repositories;

use App\Models\UserImage;
use App\Helpers\FileManager;

/**
 * Class UserImageRepository
 *
 * Properties
 * @property UserImage $model;
 */
class UserImageRepository
{
    /**
     * @var UserImage
     */
    public $model;

    /**
     * UserImageRepository constructor.
     */
    public function __construct()
    {
        $this->model = new UserImage();
    }

    /**
     * @param $image
     * @param $type
     * @param $user_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function save($image, $type, $user_id) {
        $image_path = FileManager::saveImage( $image, $type );

        $result = $this->model->create([
            'user_id' => $user_id,
            'image_path' => $image_path
        ]);

        if(!$result) {
            return response()->json(['message' => 'Image did not save']);
        }

        return $result;
    }

}