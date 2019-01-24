<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class Category
 *
 * Properties
 * @property integer $id
 * @property string $name
 * @property string $title
 *
 * Relationships
 * @property Profession $professions
 */
class Category extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'title'
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'name' => 'string',
        'title' => 'string'
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function professions()
    {
        return $this->hasMany(Profession::class, 'category_id');
    }

    #endregion
}
