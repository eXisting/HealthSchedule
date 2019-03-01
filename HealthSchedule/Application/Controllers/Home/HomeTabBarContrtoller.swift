//
//  RootTabBarContrtoller.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol SetupableTabBarItem {
  func setupTabBarItem()
}

class HomeTabBarContrtoller: UITabBarController {
  private let homeController = HomeViewController()
  private let accountController = AccountViewController()
  private let historyController = HistoryViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tabBarItems = [homeController, historyController, accountController]
    tabBarItems.forEach { item in
      (item as! SetupableTabBarItem).setupTabBarItem()
    }
    
    setViewControllers(tabBarItems, animated: true)
    
    view.backgroundColor = .white
  }
}
