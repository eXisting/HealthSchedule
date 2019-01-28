<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class Recommendation
 *
 * Properties
 * @property integer $id
 * @property integer $user_id
 * @property integer $provider_id
 * @property string $title
 * @property string $description
 * @property boolean $is_active
 *
 * Relationships
 * @property User $user
 * @property User $provider
 */
class Recommendation extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id', 'provider_id', 'title', 'description', 'is_active'
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'user_id' => 'integer',
        'provider_id' => 'integer',
        'title' => 'string',
        'description' => 'string',
        'is_active' => 'boolean',
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
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function provider()
    {
        return $this->hasOne(User::class, 'id', 'provider_id');
    }

    #endregion

    #region Scopes

    /**
     * Scope a query to only include active recommendations.
     *
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', 1);
    }

    #endregion
}
