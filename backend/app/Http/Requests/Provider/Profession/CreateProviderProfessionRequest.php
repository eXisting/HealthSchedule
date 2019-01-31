<?php

namespace App\Http\Requests;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Class CreateProviderProfessionRequest
 *
 * Properties
 * @property integer $profession_id
 * @property string $company_name
 * @property integer $city_id
 * @property Carbon $start_at
 * @property Carbon $end_at
 */
class CreateProviderProfessionRequest extends FormRequest
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
            'profession_id' => 'required|integer|exists:professions,id',
            'company_name' => 'required|string',
            'city_id' => 'required|integer|exists:cities,id',
            'start_at' => 'required|date|date_format:"Y-m-d"',
            'end_at' => 'required|date|date_format:"Y-m-d"',
        ];
    }
}
