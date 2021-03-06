<?php

namespace App\Http\Requests\User\Request;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Class UpdateUserRequestRateRequest
 *
 * Properties
 * @property integer $rate
 */
class UpdateUserRequestRateRequest extends FormRequest
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
            'rate' => 'required|integer',
        ];
    }
}
