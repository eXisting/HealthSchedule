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

class MainTabBarController: UITabBarController {
  private var homeNavigationController: HomeNavigationController!
  private var historyNavigationController: HistoryNavigationController!
  
  private let homeTab = HomeViewController()
  private let historyTab = HistoryViewController()
  private let accountTab = AccountViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    homeNavigationController = HomeNavigationController(rootViewController: homeTab)
    historyNavigationController = HistoryNavigationController(rootViewController: historyTab)
    
    let tabBarItems = [homeNavigationController, historyNavigationController, accountTab]

    tabBarItems.forEach { item in
      guard let navigationController = item as? UINavigationController else {
        (item as! SetupableTabBarItem).setupTabBarItem()
        return
      }

      (navigationController.viewControllers.first as! SetupableTabBarItem).setupTabBarItem()
    }

    setViewControllers((tabBarItems as! [UIViewController]), animated: true)
    
    view.backgroundColor = .white
  }
}
