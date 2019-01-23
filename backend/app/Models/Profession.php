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
 * @property Category $category
 * @property Service $services
 * @property User $providers
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

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function services()
    {
        return $this->hasMany(Service::class, 'profession_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasManyThrough
     */
    public function providers()
    {
        return $this->hasManyThrough(User::class, ProviderProfession::class, 'profession_id', 'id', 'id', 'provider_id');
    }

    #endregion
}
