<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ProviderSchedule
 *
 * Properties
 * @property integer $id
 * @property integer $provider_id
 * @property integer $week_day
 * @property Carbon $start_time
 * @property Carbon $end_time
 * @property boolean $working
 *
 * Relationships
 */
class ProviderSchedule extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'provider_id', 'week_day', 'start_time', 'end_time', 'working',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'provider_id' => 'integer',
        'week_day' => 'integer',
        'start_time' => 'datetime:H-i',
        'end_time' => 'datetime:H-i',
        'working' => 'boolean',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}