<?php

namespace App\Http\Requests\Auth;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\UploadedFile;

/**
 * Class ProviderRegisterRequest
 *
 * Properties
 * @property string $email
 * @property string $phone
 * @property string $password
 * @property string $first_name
 * @property string $last_name
 * @property UploadedFile $photo
 * @property integer $city_id
 * @property Carbon $birthday
 * @property array $professions
 * @property string $address
 * @property array $verifies
 */
class ProviderRegisterRequest extends FormRequest
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
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'nullable|string|max:12|unique:users',
            'password' => 'required|string|min:6',
            'first_name' => 'required|string|max:64',
            'last_name' => 'required|string|max:64',
            'photo' => 'nullable|image|mimes:jpeg,jpg,png',
            'city_id' => 'required|integer|exists:cities,id',
            'birthday' => 'required|date|date_format:"Y-m-d H:i:s"',
            'professions' => 'required',
            'professions.*' => 'required|integer|exists:professions,id',
            'address' => 'required|string|max:255',
            'verifies' => 'required',
            'verifies.*' => 'required|image|mimes:jpeg,jpg,png'
        ];
    }
}
