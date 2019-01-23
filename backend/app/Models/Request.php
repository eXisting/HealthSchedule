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
 * @property integer $provider_service_id
 * @property integer $status_id
 * @property integer $rate
 * @property string $description
 * @property Carbon $request_at
 *
 * Relationships
 * @property User $user
 * @property ProviderService $providerService
 * @property RequestStatus $status
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
        'user_id', 'provider_service_id', 'status_id', 'rate', 'description', 'request_at',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'user_id' => 'integer',
        'provider_service_id' => 'integer',
        'status_id' => 'integer',
        'rate' => 'integer',
        'description' => 'string',
        'request_at' => 'datetime',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function providerService()
    {
        return $this->belongsTo(ProviderService::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function status()
    {
        return $this->hasOne(RequestStatus::class, 'id', 'status_id');
    }

    #endregion
}
