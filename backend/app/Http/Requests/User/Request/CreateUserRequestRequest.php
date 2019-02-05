<?php

namespace App\Http\Requests\User\Request;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Class CreateUserRequestRequest
 *
 * Properties
 * @property integer $provider_id
 * @property integer $service_id
 * @property string $description
 * @property Carbon $request_at
 */
class CreateUserRequestRequest extends FormRequest
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
            'provider_id' => 'required|integer|exists:users,id',
            'service_id' =>  'required|integer|exists:services,id',
            'description' => 'required|string',
            'request_at' =>  'required|date|date_format:"Y-m-d H:i:s"',
        ];
    }
}
