//
//  ControllersExtensions.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/27/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol DataSourceContaining {
  var dataSource: UITableViewDataSource { get }
}

extension UIViewController {
  
  /// Methods allows your view controller to dismiss any keyboard handled on outside area tapped. It is using gesture recognizer on self
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
