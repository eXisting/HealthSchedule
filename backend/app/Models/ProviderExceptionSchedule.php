<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ProviderExceptionSchedule
 *
 * Properties
 * @property integer $id
 * @property integer $provider_id
 * @property Carbon $exception_at
 * @property Carbon $start_time
 * @property Carbon $end_time
 * @property boolean $working
 *
 * Relationships
 * @property User $provider
 */
class ProviderExceptionSchedule extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'provider_id', 'exception_at', 'start_time', 'end_time', 'working',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'provider_id' => 'integer',
        'exception_at' => 'datetime:Y-m-d',
        'start_time' => 'datetime:H-i',
        'end_time' => 'datetime:H-i',
        'working' => 'boolean',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function provider()
    {
        return $this->hasOne(User::class, 'id', 'provider_id');
    }

    #endregion
}
