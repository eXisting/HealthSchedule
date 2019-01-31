<?php

namespace App\Http\Requests\Provider\Verify;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Class CreateProviderVerifiesRequest
 *
 * Properties
 * @property array $verifies
 */
class CreateProviderVerifiesRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'verifies' => 'required',
            'verifies.*' => 'required|image|mimes:jpeg,jpg,png'
        ];
    }
}
