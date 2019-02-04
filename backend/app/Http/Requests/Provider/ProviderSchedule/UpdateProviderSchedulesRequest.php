<?php

namespace App\Http\Requests\Provider\ProviderSchedule;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Class UpdateProviderSchedulesRequest
 *
 * Properties
 * @property array $schedules
 */
class UpdateProviderSchedulesRequest extends FormRequest
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
            'schedules' => 'required',
            'schedules.*.week_day' => 'required|integer',
            'schedules.*.start_time' => 'required|date_format:H:i',
            'schedules.*.end_time' => 'required|date_format:H:i',
            'schedules.*.working' => 'required|boolean',
        ];
    }
}
