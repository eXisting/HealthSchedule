//
//  ValidationController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ValidationType: String {
  case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
  case name = "[a-zA-Z]{3,20}$"
  case password = ".{8,}"
  case phone = "^[0-9]{12}$"
}

class ValidationController {
  static let shared = ValidationController()
  
  private init() {}
  
  func validate(_ text: String, ofType regex: ValidationType) -> Bool {
    let regEx = regex.rawValue
    
    let test = NSPredicate(format:"SELF MATCHES %@", regEx)
//    let res = test.evaluate(with: text)
//    print(res)
    return test.evaluate(with: text)
  }
  
  func confirmPassword(_ password: String, _ confirm: String) -> Bool {
    return !password.isEmpty && !confirm.isEmpty && password == confirm
  }
}
