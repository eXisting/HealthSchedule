<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class Profession
 *
 * Properties
 * @property integer $id
 * @property integer $category_id
 * @property string $name
 * @property string $title
 *
 * Relationships
 */
class Profession extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'category_id', 'name', 'title',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'category_id' => 'integer',
        'name' => 'string',
        'title' => 'string',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    public function services()
    {
        return $this->hasMany(Service::class, 'profession_id');
    }

    #endregion
}
