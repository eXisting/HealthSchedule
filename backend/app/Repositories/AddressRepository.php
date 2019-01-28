<?php

namespace App\Repositories;

use App\Models\Address;

/**
 * Class AddressRepository
 *
 * Properties
 * @property Address $model;
 */
class AddressRepository
{
    /**
     * @var Address
     */
    public $model;

    /**
     * AddressRepository constructor.
     */
    public function __construct()
    {
        $this->model = new Address();
    }

    /**
     * @param $address
     * @return Address
     */
    public function findOrCreate($address)
    {
        $result = $this->model->firstOrCreate(['address' => $address], ['address' => $address]);

        if(!$result) {
            return response()->json(['message' => 'Address not found and did not create']);
        }

        return $result;
    }

}