<?php

namespace App\Http\Interfaces;

use Illuminate\Http\Request;

interface RegisterInterface
{
    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function register();
}
