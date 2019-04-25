<?php

namespace App\Http\Controllers;

use Edujugon\PushNotification\PushNotification;

class PushNotificationsController extends Controller
{
    public static function sendNewRequestNotification($deviceToken, $userName) 
    {
        $iosPush = new PushNotification('apn');
        
        $iosPush->setMessage([
            'aps' => [
                'alert' => [
                    'title' => 'There is a new request for you!',
                    'body' => $userName . " has booked something from your services!"
                ],
                'sound' => 'default',
                'badge' => 1

            ]
        ])
        ->setDevicesToken($deviceToken);
    }
}
