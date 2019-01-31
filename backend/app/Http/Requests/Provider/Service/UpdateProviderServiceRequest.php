<?php

namespace App\Http\Requests\Provider\Service;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

/**
 * Class UpdateProviderServiceRequest
 *
 * Properties
 * @property string $address
 * @property integer $service_id
 * @property double $price
 * @property string $description
 * @property Carbon $interval
 */
class UpdateProviderServiceRequest extends FormRequest
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
            'address' => 'required|string',
            'service_id' => 'required|integer|exists:services,id',
            'price' => 'required|numeric',
            'description' => 'required|string',
            'interval' => 'required|date|date_format:"H:i"',
        ];
    }
}
