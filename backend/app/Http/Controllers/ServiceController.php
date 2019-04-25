<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\City;
use App\Models\Service;

class ServiceController extends Controller
{
    public function all(Request $request)
    {
        $cityId = $request->get('city_id');
        /** @var City $city */
        $city = City::findOrFail($cityId);
        return response()->json($city->services());
    }
    
    public function getAllServices(Request $request)
    {
        return response()->json(Service::all());
    }
    
    public function getService(Request $request) 
    {
        return response()->json(Service::find($request->id));
    }
}
