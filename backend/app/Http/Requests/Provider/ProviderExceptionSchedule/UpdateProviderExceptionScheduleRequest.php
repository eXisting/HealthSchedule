<?php

namespace App\Http\Requests\Provider\ProviderExceptionSchedule;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Class UpdateProviderExceptionScheduleRequest
 *
 * @property Carbon $start_time
 * @property Carbon $end_time
 * @property boolean $working
 */
class UpdateProviderExceptionScheduleRequest extends FormRequest
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
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'required|date_format:H:i',
            'working' => 'required|boolean',
        ];
    }
}
