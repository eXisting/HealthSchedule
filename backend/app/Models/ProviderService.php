<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ProviderService
 *
 * Properties
 * @property integer $id
 * @property integer $address_id
 * @property integer $provider_id
 * @property integer $service_id
 * @property double $price
 * @property string $description
 * @property Carbon $interval
 *
 * Relationships
 */
class ProviderService extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'address_id', 'provider_id', 'service_id', 'price', 'description', 'interval',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'address_id' => 'integer',
        'provider_id' => 'integer',
        'service_id' => 'integer',
        'price' => 'double',
        'description' => 'string',
        'interval' => 'datetime:H-m',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
