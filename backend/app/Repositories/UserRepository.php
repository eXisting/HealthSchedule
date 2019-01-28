<?php

namespace App\Repositories;

use App\Models\User;

/**
 * Class UserRepository
 *
 * Properties
 * @property User $model;
 */
class UserRepository
{
    /**
     * @var User
     */
    public $model;

    /**
     * UserRepository constructor.
     */
    public function __construct()
    {
        $this->model = new User();
    }
}