<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class Address
 *
 * Properties
 * @property integer $id
 * @property string $address
 *
 * Relationships
 */
class Address extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'address',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'address' => 'string',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
