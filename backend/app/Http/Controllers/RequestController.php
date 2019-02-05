<?php

namespace App\Http\Controllers;

use App\Models\Request;
use App\Models\User;
use App\Repositories\RequestRepository;
use Gate;

/**
 * Class RequestController
 *
 * Properties
 * @property User $authUser
 * @property RequestRepository $request
 */
class RequestController extends AuthUserController
{
    /**
     * @var RequestRepository
     */
    protected $request;

    /**
     * RequestController constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->request = new RequestRepository();
    }


    /**
     * @param Request $request
     * @param string $status
     * @return \Illuminate\Http\JsonResponse
     */
    public function changeStatus(Request $request, $status)
    {
        if(Gate::denies('provider-change-status-request', $request)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        if($status == 'active') {
            $request->update([ 'status' => 1 ]);
        } elseif ($status == 'inactive') {
            $request->update([ 'status' => 0 ]);
        } else {
            return response()->json(['message' => ' {Status} parameter is missing or bad']);
        }

        return response()->json(['success' => true]);
    }
}
