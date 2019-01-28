<?php

namespace App\Repositories;

use App\Models\ProviderVerify;
use App\Helpers\FileManager;

/**
 * Class ProviderVerifyRepository
 *
 * Properties
 * @property ProviderVerify $model;
 */
class ProviderVerifyRepository
{
    /**
     * @var ProviderVerify
     */
    public $model;

    /**
     * ProviderVerifyRepository constructor.
     */
    public function __construct()
    {
        $this->model = new ProviderVerify();
    }


    /**
     * @param $image
     * @param $type
     * @param $provider_id
     * @return \Illuminate\Http\JsonResponse
     */
    public function save($image, $type, $provider_id) {
        $doc_path = FileManager::saveImage( $image, $type );

        $result = $this->model->create([
            'provider_id' => $provider_id,
            'document_path' => $doc_path
        ]);

        if(!$result) {
            return response()->json(['message' => 'Verify did not save']);
        }

        return $result;
    }

}