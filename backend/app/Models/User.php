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
 * @property UserRole $role
 * @property Address $address
 * @property City $city
 * @property ProviderService $providerServices
 * @property Profession $professions
 * @property UserImage $image
 * @property ProviderSchedule $providerSchedules
 * @property ProviderExceptionSchedule $providerExceptionSchedules
 * @property Request $userRequests
 * @property Request $providerRequests
 * @property Recommendation $userRecommendations
 * @property Recommendation $providerRecommendations
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

    /**
     * @return mixed
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }

    #endregion

    #region Relationships

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function role()
    {
        return $this->belongsTo(UserRole::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function address()
    {
        return $this->belongsTo(Address::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function city()
    {
        return $this->belongsTo(City::class);
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function providerServices()
    {
        return $this->hasOne(ProviderService::class, 'provider_id', 'id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasManyThrough
     */
    public function professions()
    {
        return $this->hasManyThrough(Profession::class, ProviderProfession::class, 'provider_id', 'id', 'id', 'profession_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function image()
    {
        return $this->hasOne(UserImage::class, 'user_id', 'id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function providerSchedules()
    {
        return $this->hasMany(ProviderSchedule::class, 'provider_id', 'id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function providerExceptionSchedules()
    {
        return $this->hasMany(ProviderExceptionSchedule::class, 'provider_id', 'id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function userRequests()
    {
        return $this->hasMany(Request::class, 'user_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasManyThrough
     */
    public function providerRequests()
    {
        return $this->hasManyThrough(Request::class, ProviderService::class, 'provider_id', 'id', 'id', 'provider_service_id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function userRecommendations()
    {
        return $this->hasMany(Recommendation::class, 'user_id', 'id');
    }

    /**
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function providerRecommendations()
    {
        return $this->hasMany(Recommendation::class, 'provider_id', 'id');
    }

    #endregion

}
