<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Service
 *
 * Properties
 * @property integer $id
 * @property integer $address_id
 * @property integer $provider_id
 * @property integer $profession_id
 * @property string $title
 * @property string $name
 * @property double $price
 * @property string $description
 * @property Carbon $interval
 *
 * Relationships
 */
class Service extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'address_id', 'provider_id', 'profession_id', 'title', 'name', 'price', 'description', 'interval',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'address_id' => 'integer',
        'provider_id' => 'integer',
        'profession_id' => 'integer',
        'title' => 'string',
        'name' => 'string',
        'price' => 'double',
        'description' => 'string',
        'interval' => 'datetime:H-i',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
