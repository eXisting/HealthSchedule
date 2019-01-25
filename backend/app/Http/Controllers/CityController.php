<?php

namespace App\Http\Controllers;

use App\Models\City;

class CityController extends Controller
{
    /**
     * Return list of cities
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function all()
    {
        return response()->json(City::query()->get());
    }
}
