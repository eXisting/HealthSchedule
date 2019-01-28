<?php

namespace App\Repositories;

use App\Models\Profession;

/**
 * Class ProfessionRepository
 *
 * Properties
 * @property Profession $model;
 */
class ProfessionRepository
{
    /**
     * @var Profession
     */
    public $model;

    /**
     * ProfessionRepository constructor.
     */
    public function __construct()
    {
        $this->model = new Profession();
    }

}