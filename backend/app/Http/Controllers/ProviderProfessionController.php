<?php

namespace App\Http\Controllers;

use App\Http\Requests\CreateProviderProfessionRequest;
use App\Http\Requests\Provider\Address\UpdateProviderAddressRequest;
use App\Models\ProviderProfession;
use App\Models\User;
use Gate;

/**
 * Class ProviderProfessionController
 *
 * Properties
 * @property User $authUser
 */
class ProviderProfessionController extends AuthUserController
{

    /**
     * ProviderProfessionController constructor.
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function all()
    {
        return response()->json($this->authUser->providerProfessions()->with('profession', 'city')->get());
    }

    /**
     * @param CreateProviderProfessionRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function create(CreateProviderProfessionRequest $request)
    {
        $data = array_merge($request->all(), ['provider_id' => $this->authUser->id]);

        $result = $this->authUser->providerProfessions()->create($data);

        if($result) {
            return response()->json(['success' => true]);
        }

        return response()->json(['success' => false]);
    }

    /**
     * @param ProviderProfession $profession
     * @param UpdateProviderAddressRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(ProviderProfession $profession, UpdateProviderAddressRequest $request)
    {
        if(Gate::denies('provider-update-profession', $profession)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json(['success' => $profession->update($request->all())]);
    }

    /**
     * @param ProviderProfession $profession
     * @return \Illuminate\Http\JsonResponse
     */
    public function delete(ProviderProfession $profession)
    {
        if(Gate::denies('provider-delete-profession', $profession)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        try {
            $profession->delete();
        } catch (\Exception $e) {
            return response()->json(['success' => false,'message' => $e->getMessage()]);
        }

        return response()->json(['success' => true]);
    }

}
