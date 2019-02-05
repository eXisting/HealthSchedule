<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\City;

class ServiceController extends Controller
{
    public function all(Request $request)
    {
        $cityId = $request->get('city_id');
        /** @var City $city */
        $city = City::findOrFail($cityId);
        return response()->json($city->services());
    }
}
