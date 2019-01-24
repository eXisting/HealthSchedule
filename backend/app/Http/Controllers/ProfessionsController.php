<?php

namespace App\Http\Controllers;

use App\Models\Category;

class ProfessionsController extends Controller
{
    public function professions(Category $category)
    {
        return response()->json($category->professions);
    }
}
