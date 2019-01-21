<?php

use Faker\Generator as Faker;

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| This directory should contain each of the model factory definitions for
| your application. Factories provide a convenient way to generate new
| model instances for testing / seeding your application's database.
|
*/

$factory->define(App\Models\User::class, function (Faker $faker) {
    return [
        'user_role_id' => rand(1,3),
        'address_id' => factory(\App\Models\Address::class)->create()->id,
        'city_id' => factory(\App\Models\City::class)->create()->id,
        'first_name' => $faker->firstName,
        'last_name' => $faker->lastName,
        'phone' => $faker->unique()->phoneNumber,
        'email' => $faker->unique()->safeEmail,
        'confirmed_status' => $faker->boolean,
        'email_verified_at' => now(),
        'password' => '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm', // secret
        'remember_token' => str_random(10),
    ];
});

$factory->define(App\Models\Address::class, function (Faker $faker) {
    return [
        'address' => $faker->address
    ];
});

$factory->define(App\Models\Category::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\City::class, function (Faker $faker) {
    $cityName = $faker->city;
    return [
        'title' => $cityName,
        'name' => mb_strtolower($cityName)

    ];
});

$factory->define(App\Models\Profession::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\ProviderExceptionSchedule::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\ProviderProfession::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\ProviderSchedule::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\ProviderVerify::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\Recommendation::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\Request::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\RequestStatus::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\Service::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\User::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\UserImage::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\UserRole::class, function (Faker $faker) {
    return [];
});