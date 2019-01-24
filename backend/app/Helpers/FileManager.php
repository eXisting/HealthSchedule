<?php
/**
 * Created by PhpStorm.
 * User: alek
 * Date: 24.01.19
 * Time: 17:54
 */

namespace App\Helpers;

use Illuminate\Http\UploadedFile;
use Intervention\Image\Facades\Image;

class FileManager
{
    /**
     * @param UploadedFile $image
     * @param string $type
     * @return string
     */
    public static function saveImage($image, $type)
    {
        $filename = time() . '_' . str_random(8) . '.' . $image->getClientOriginalExtension();
        $image_path = config('image.image-path'.$type) . $filename;

        $image = Image::make($image);
        if($image->width() > 1000 || $image->height() > 1000) {
            $image->resize($image->width()/2, $image->height()/2)->save(public_path($image_path));
        } else {
            $image->save(public_path($image_path));
        }

        return $image_path;
    }
}