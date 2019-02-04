<?php

namespace App\Http\Requests\User\Request;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Class UpdateUserRequestRequest
 *
 * Properties
 * @property string $description
 * @property Carbon $request_at
 */
class UpdateUserRequestRequest extends FormRequest
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
            'description' => 'required|string',
            'request_at' =>  'required|date|date_format:"Y-m-d H:i:s"',
        ];
    }
}
