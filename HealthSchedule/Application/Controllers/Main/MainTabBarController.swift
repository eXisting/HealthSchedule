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

protocol RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void)
}

class MainTabBarController: UITabBarController {
  private var homeNavigationController: SearchNavigationController!
  private var requestNavigationController: UINavigationController!
  private var accountNavigationController: UINavigationController!

  private let homeTab = SearchViewController()
  private let requestTab = RequestViewController()
  private let accountTab = AccountViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    homeNavigationController = SearchNavigationController(rootViewController: homeTab)
    requestNavigationController = UINavigationController(rootViewController: requestTab)
    accountNavigationController = UINavigationController(rootViewController: accountTab)

    let tabBarItems = [
      homeNavigationController,
      requestNavigationController,
      accountNavigationController
    ]

    tabBarItems.forEach { item in
      (item?.viewControllers.first as! SetupableTabBarItem).setupTabBarItem()
    }

    setViewControllers((tabBarItems as! [UIViewController]), animated: true)
    
    view.backgroundColor = .white
  }
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    viewControllers?.forEach {
      controller in (controller as? UINavigationController)?.popToRootViewController(animated: false)
    }
  }
}
