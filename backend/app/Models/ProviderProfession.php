<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ProviderProfession
 *
 * Properties
 * @property integer $id
 * @property integer $provider_id
 * @property integer $profession_id
 * @property integer $city_id
 * @property string $company_name
 * @property Carbon $start_at
 * @property Carbon $end_at
 *
 * Relationships
 * @property User $provider
 * @property Profession $profession
 * @property City $city
 */
class ProviderProfession extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'provider_id', 'profession_id', 'city_id', 'company_name', 'start_at', 'end_at',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'provider_id' => 'integer',
        'profession_id' => 'integer',
        'city_id' => 'integer',
        'company_name' => 'string',
        'start_at' => 'datetime',
        'end_at' => 'datetime',
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

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function profession()
    {
        return $this->belongsTo(Profession::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function city()
    {
        return $this->belongsTo(City::class);
    }

    #endregion
}
