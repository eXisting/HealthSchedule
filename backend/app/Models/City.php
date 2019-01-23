<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class City
 *
 * Properties
 * @property integer $id
 * @property string $name
 * @property string $title
 *
 * Relationships
 */
class City extends Model
{
    #region Properties

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

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function providers()
    {
        return $this->hasMany(User::class)->where('user_role_id', UserRole::PROVIDER);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function clients()
    {
        return $this->hasMany(User::class)->where('user_role_id', UserRole::CLIENT);
    }

    #endregion
}
