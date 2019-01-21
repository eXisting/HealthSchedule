<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Request
 *
 * Properties
 * @property integer $id
 * @property integer $user_id
 * @property integer $service_id
 * @property integer $status_id
 * @property integer $rate
 * @property string $description
 * @property Carbon $request_at
 *
 * Relationships
 */
class Request extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id', 'service_id', 'status_id', 'rate', 'description', 'request_at',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'user_id' => 'integer',
        'service_id' => 'integer',
        'status_id' => 'integer',
        'rate' => 'integer',
        'description' => 'string',
        'request_at' => 'datetime',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
