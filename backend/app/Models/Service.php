<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class Service
 *
 * Properties
 * @property integer $id
 * @property integer $profession_id
 * @property string $title
 * @property string $name
 *
 * Relationships
 * @property Profession $profession
 * @property ProviderService $providerServices
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
        'profession_id', 'title', 'name',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'profession_id' => 'integer',
        'title' => 'string',
        'name' => 'string',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function profession()
    {
        return $this->belongsTo(Profession::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function providerServices()
    {
        return $this->hasMany(ProviderService::class, 'service_id', 'id');
    }

    #endregion
}
