<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class ProviderVerify
 *
 * Properties
 * @property integer $id
 * @property integer $provider_id
 * @property string $document_path
 *
 * Relationships
 */
class ProviderVerify extends Model
{
    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'provider_id', 'document_path',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'provider_id' => 'integer',
        'document_path' => 'string',
    ];

    #endregion

    #region Methods

    #endregion

    #region Relationships

    #endregion
}
