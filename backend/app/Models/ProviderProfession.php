<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class ProviderProfession
 *
 * Properties
 * @property integer $id
 * @property integer $provider_id
 * @property integer $profession_id
 *
 * Relationships
 * @property User $provider
 * @property Profession $profession
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
        'provider_id', 'profession_id',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'provider_id' => 'integer',
        'profession_id' => 'integer',
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

    #endregion
}
