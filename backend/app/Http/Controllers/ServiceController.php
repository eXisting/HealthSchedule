<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\City;
use App\Models\Service;
use App\Models\Category;

class ServiceController extends Controller
{
    public function all(Request $request)
    {
        $cityId = $request->get('city_id');
        /** @var City $city */
        $city = City::findOrFail($cityId);
        return response()->json($city->services($request->get('category_id')));
    }
    
    public function getAllServices(Category $category)
    {
        $professions = $category->professions->all();
        
        $services = Service::all();
        
        $result = [];
        foreach ($services as $service)
        {
            foreach ($professions as $profession)
            {
                if ($profession->id == $service->profession_id)
                {
                    $result[] = $service;
                }
            }
        }
        
        return response()->json($result);
        // pagination
        // return response()->json(Service::paginate(20));
    }
    
    public function getService(Request $request) 
    {
        return response()->json(Service::find($request->id));
    }
}
