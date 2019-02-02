<?php

namespace App\Http\Controllers;

use App\Http\Requests\Provider\Profession\CreateProviderProfessionRequest;
use App\Http\Requests\Provider\Profession\UpdateProviderProfessionRequest;
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

        try {
            $this->authUser->providerProfessions()->create($data);
        } catch (\Exception $e) {
            return response()->json(['success' => false,'message' => $e->getMessage()]);
        }

        $result = $this->authUser->providerProfessions()->create($data);

        if($result) {
            return response()->json(['success' => true]);
        }

        return response()->json(['success' => false]);
    }

    /**
     * @param ProviderProfession $providerProfession
     * @param UpdateProviderProfessionRequest $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(ProviderProfession $providerProfession, UpdateProviderProfessionRequest $request)
    {
        if(Gate::denies('provider-update-profession', $providerProfession)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        return response()->json(['success' => $providerProfession->update($request->all())]);
    }

    /**
     * @param ProviderProfession $providerProfession
     * @return \Illuminate\Http\JsonResponse
     */
    public function delete(ProviderProfession $providerProfession)
    {
        if(Gate::denies('provider-delete-profession', $providerProfession)) {
            return response()->json(['message' => 'Not enough rights']);
        }

        try {
            $providerProfession->delete();
        } catch (\Exception $e) {
            return response()->json(['success' => false,'message' => $e->getMessage()]);
        }

        return response()->json(['success' => true]);
    }

}
