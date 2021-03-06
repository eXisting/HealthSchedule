<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class UserRole
 *
 * Properties
 * @property integer $id
 * @property string $name
 * @property string $title
 *
 * Relationships
 */
class UserRole extends Model
{
    #region Properties

    CONST CLIENT = 2;
    CONST PROVIDER = 1;
    CONST ADMIN = 3;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'title',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'name' => 'string',
        'title' => 'string',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
