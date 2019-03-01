//
//  RootTabBarContrtoller.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeTabBarContrtoller: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let homeController = HomeViewController()
    let accountController = AccountViewController()
    
    setViewControllers([homeController, accountController], animated: true)
    
    view.backgroundColor = .white
  }
}
