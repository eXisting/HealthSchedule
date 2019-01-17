//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignUpViewController: UITabBarController {
  
  var rootNaviationController: RootNavigationController?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    rootNaviationController = self.navigationController as? RootNavigationController
  }
}
