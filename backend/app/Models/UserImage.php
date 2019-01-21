<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class UserImage
 *
 * Properties
 * @property integer $id
 * @property integer $user_id
 * @property string $image_path
 *
 * Relationships
 */
class UserImage extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id', 'image_path',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'user_id' => 'integer',
        'image_path' => 'string',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
