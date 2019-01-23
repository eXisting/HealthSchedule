<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class RequestStatus
 *
 * Properties
 * @property integer $id
 * @property string $name
 * @property string $title
 *
 * Relationships
 * @property Request $requests
 */
class RequestStatus extends Model
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
    public function requests()
    {
        return $this->hasMany(Request::class, 'status_id', 'id');
    }

    #endregion
}
