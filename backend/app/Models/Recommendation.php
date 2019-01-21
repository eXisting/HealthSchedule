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
 *
 * Relationships
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
        'user_id', 'provider_id', 'title', 'description',
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
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
