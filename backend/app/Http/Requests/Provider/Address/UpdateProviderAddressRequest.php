<?php

namespace App\Http\Requests\Provider\Address;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Class UpdateProviderAddressRequest
 *
 * Properties
 * @property string $address
 */
class UpdateProviderAddressRequest extends FormRequest
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
            'address' => 'required|string|max:255',
        ];
    }
}
