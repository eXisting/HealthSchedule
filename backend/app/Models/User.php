<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Notifications\Notifiable;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Tymon\JWTAuth\Contracts\JWTSubject;

/**
 * Class User
 *
 * Properties
 * @property string $id
 * @property integer $user_role_id
 * @property integer $address_id
 * @property integer $city_id
 * @property string $first_name
 * @property string $last_name
 * @property string $phone
 * @property string $email
 * @property string $password
 * @property boolean $confirmed_status
 * @property Carbon $email_verified_at
 * @property Carbon $birthday_at
 *
 * Relationships
 */
class User extends Authenticatable implements JWTSubject
{
    use Notifiable;

    #region Properties

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_role_id',
        'address_id',
        'city_id',
        'first_name',
        'last_name',
        'phone',
        'email',
        'password',
        'confirmed_status',
        'email_verified_at',
        'birthday_at',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'user_role_id' => 'integer',
        'address_id' => 'integer',
        'city_id' => 'integer',
        'first_name' => 'string',
        'last_name' => 'string',
        'phone' => 'string',
        'email' => 'string',
        'password' => 'string',
        'confirmed_status' => 'boolean',
        'email_verified_at' => 'datetime',
        'birthday_at' => 'datetime',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    #endregion

    #region Methods

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    #endregion

    #region Relationships

    public function city()
    {
        return $this->belongsTo(City::class);
    }

    public function professions()
    {
        return $this->hasManyThrough(Profession::class, ProviderProfession::class, 'provider_id', 'id', 'id', 'profession_id');
    }

    #endregion

}
