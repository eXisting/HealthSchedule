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
        'user_role_id' => \App\Models\UserRole::all()->random()->id,
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
    $category = $faker->word;
    return [
        'title' => $category,
        'name' => str_slug($category, '_')

    ];
});

$factory->define(App\Models\City::class, function (Faker $faker) {
    $cityName = $faker->city;
    return [
        'title' => $cityName,
        'name' => str_slug($cityName, '_')

    ];
});

$factory->define(App\Models\Profession::class, function (Faker $faker) {
    $profession = $faker->word;
    return [
        'title' => $profession,
        'name' => str_slug($profession, '_')

    ];
});

$factory->define(App\Models\ProviderExceptionSchedule::class, function (Faker $faker) {
    return [
        'working' => $faker->boolean,
    ];
});

$factory->define(App\Models\ProviderProfession::class, function (Faker $faker) {
    return [
//        'provider_id' => \App\Models\User::query()->inRandomOrder()->first()->id,
//        'profession_id' => \App\Models\Profession::,
    ];
});

$factory->define(App\Models\ProviderSchedule::class, function (Faker $faker) {
    return [
        'working' => $faker->boolean,
    ];
});

$factory->define(App\Models\ProviderVerify::class, function (Faker $faker) {
    return [
        'provider_id' => \App\Models\User::query()->where('user_role_id', \App\Models\UserRole::PROVIDER)->inRandomOrder()->first()->id,
        'document_path' => $faker->imageUrl()
    ];
});

$factory->define(App\Models\Recommendation::class, function (Faker $faker) {
    return [
        'user_id' => \App\Models\User::query()->where('user_role_id', \App\Models\UserRole::CLIENT)->inRandomOrder()->first()->id,
        'provider_id' =>\App\Models\User::query()->where('user_role_id', \App\Models\UserRole::PROVIDER)->inRandomOrder()->first()->id,
        'title' => $faker->jobTitle,
        'description' => $faker->text(350),
    ];
});

$factory->define(App\Models\Request::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\RequestStatus::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\Service::class, function (Faker $faker) {
    return [
        'address_id' => 'integer',
        'provider_id' => 'integer',
        'profession_id' => 'integer',
        'title' => 'string',
        'name' => 'string',
        'price' => 'double',
        'description' => 'string',
        'interval' => 'datetime:H-i',
    ];
});

$factory->define(App\Models\UserImage::class, function (Faker $faker) {
    return [
        'image_path' => $faker->imageUrl()
    ];
});

$factory->define(App\Models\UserRole::class, function (Faker $faker) {
    return [];
});