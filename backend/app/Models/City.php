<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

/**
 * Class City
 *
 * Properties
 * @property integer $id
 * @property string $name
 * @property string $title
 *
 * Relationships
 * @property User $providers
 * @property User $users
 */
class City extends Model
{
    //region Properties

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

    //endregion

    //region Methods

    //endregion

    //region Relationships

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
    public function users()
    {
        return $this->hasMany(User::class)->where('user_role_id', UserRole::CLIENT);
    }

    /**
     * Method returns all services in specific city
     *
     * @return \Illuminate\Support\Collection
     */
    public function services($category_id)
    {
        //select * from services
        //left join provider_services on provider_services.service_id = services.id
        //left join users on provider_services.provider_id = users.id
        //left join cities on users.city_id = cities.id
        //where cities.id = 1
        return DB::table('services')
            ->select('services.id', 'services.name', 'services.title', 'services.profession_id')
            ->leftJoin('provider_services', 'provider_services.service_id', '=', 'services.id')
            ->leftJoin('professions', 'professions.id', '=', 'services.id')
            ->leftJoin('users', 'provider_services.provider_id', '=', 'users.id')
            ->leftJoin('cities', 'users.city_id', '=', 'cities.id')
            ->groupBy('services.id')
            ->where('cities.id', $this->id)
            ->where('professions.category_id', $category_id)
            ->get();
    }

    //endregion
}
