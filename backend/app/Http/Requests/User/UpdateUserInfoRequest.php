<?php

namespace App\Http\Requests\User;

use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Class UpdateUserInfoRequest
 *
 * Properties
 * @property integer $city_id
 * @property string $first_name
 * @property string $last_name
 * @property string $email
 * @property string $phone
 * @property Carbon $birthday
 */
class UpdateUserInfoRequest extends FormRequest
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
        /** @var User $user */
        $user = auth('api')->user();

        return [
            'email' => 'required|email|max:255|unique:users,email,'.$user->id,
            'phone' => 'nullable|string|max:12|unique:users,phone,'.$user->id,
            'first_name' => 'required|string|max:64',
            'last_name' => 'required|string|max:64',
            'city_id' => 'required|integer|exists:cities,id',
            'birthday_at' => 'required|date|date_format:"Y-m-d"',
        ];
    }
}
