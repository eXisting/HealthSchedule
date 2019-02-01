//
//  AlertHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AlertHandler {
  
  private class func createAlert(_ title: String,
                           _ message: String,
                           _ style: UIAlertController.Style) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(
      title: "OK",
      style: UIAlertAction.Style.default,
      handler: nil))
    
    return alert
  }
  
  static func ShowAlert(for viewController: UIViewController,
                        _ title: String,
                        _ message: String,
                        _ style: UIAlertController.Style) {
    viewController.present(
      createAlert(title, message, .alert),
      animated: true,
      completion: nil)
  }
  
}
