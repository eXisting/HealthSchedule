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
        'city_id' => \App\Models\City::query()->inRandomOrder()->first()->id,
        'company_name' => $faker->company,
        'start_at' => \Carbon\Carbon::create(2000 - rand(1, 10), rand(1, 12))->toDateTimeString(),
        'end_at' => \Carbon\Carbon::create(2000 + rand(1, 10), rand(1, 12))->toDateTimeString(),
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
        'provider_id' => \App\Models\User::query()->where('user_role_id', \App\Models\UserRole::PROVIDER)->inRandomOrder()->first()->id,
        'title' => $faker->jobTitle,
        'description' => $faker->text(350),
        'is_active' => $faker->boolean
    ];
});

$factory->define(App\Models\Request::class, function (Faker $faker) {
    $status = $faker->boolean;
    switch (rand(1, 3)) {
        case 1:
            $status = true;
            break;
        case 2:
            $status = false;
            break;
        case 3:
            $status = null;
            break;
    }
    return [
        'user_id' => \App\Models\User::query()->where('user_role_id', \App\Models\UserRole::CLIENT)->inRandomOrder()->first()->id,
        'provider_service_id' => \App\Models\ProviderService::query()->inRandomOrder()->first()->id,
        // 'status_id' => \App\Models\RequestStatus::query()->inRandomOrder()->first()->id,
        'status' => $status,
        'rate' => $status ? rand(1, 5) : null,
        'description' => $faker->text,
        'request_at' => $status ? \Carbon\Carbon::now()->addDays(rand(-10, -1))->toDateTimeString() : \Carbon\Carbon::now()->addDays(rand(5, 60))->toDateTimeString(),
    ];
});

$factory->define(App\Models\RequestStatus::class, function (Faker $faker) {
    return [];
});

$factory->define(App\Models\Service::class, function (Faker $faker) {
    $service = $faker->word;
    return [
        'profession_id' => \App\Models\Profession::query()->inRandomOrder()->first()->id,
        'title' => $service,
        'name' => str_slug($service, '_'),
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

$factory->define(App\Models\ProviderService::class, function (Faker $faker) {
    $minutes = collect([15, 30, 45]);

    return [
        'address_id' => factory(\App\Models\Address::class)->create()->id,
        'price' => rand(100, 500),
        'name' => $faker->name,
        'description' => $faker->text,
        'interval' => \Carbon\Carbon::createFromTime(rand(0, 1), $minutes->random())
    ];
});
