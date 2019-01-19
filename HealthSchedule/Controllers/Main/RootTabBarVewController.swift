//
//  RootTabBarVewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/16/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {
  
  private lazy var signUpData: [String: Any] = [:]
  
  func storeSignUpData(_ data: [String: Any]) {
    for (key, value) in data {
      signUpData[key] = value
    }
  }
}
