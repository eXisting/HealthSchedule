//
//  RootTabBarContrtoller.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

protocol SetupableTabBarItem {
  func setupTabBarItem()
}

protocol RefreshingTableView {
  func refresh(_ completion: @escaping (String) -> Void)
}

class MainTabBarController: UITabBarController, NVActivityIndicatorViewable {
  private var homeNavigationController: UINavigationController!
  private var requestNavigationController: UINavigationController!
  private var accountNavigationController: UINavigationController!

  private let homeTab = SearchViewController()
  private let requestTab = RequestViewController()
  private let accountTab = AccountViewController()
  
  lazy var requestManager = CommonDataRequest()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    preloadRequiredData()
    
    view.backgroundColor = .white
  }
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    viewControllers?.forEach {
      controller in (controller as? UINavigationController)?.popToRootViewController(animated: false)
    }
  }
  
  private func instantiateControllers() {
    homeNavigationController = UINavigationController(rootViewController: homeTab)
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
    
    self.stopAnimating()
  }
  
  private func preloadRequiredData() {
    let semaphore = DispatchSemaphore(value: 0)
    
    requestManager.getCities { [weak self] status in
      if status != ResponseStatus.success.rawValue {
        self?.showWarningAlert(message: "Application cannot get required cities from the server!")
        exit(1);
      }
      
      semaphore.signal()
    }
    
    semaphore.wait()
    requestManager.getProfessions { [weak self] status in
      if status != ResponseStatus.success.rawValue {
        self?.showWarningAlert(message: "Application cannot get required professions from the server!")
        exit(1);
      }
      
      semaphore.signal()
    }
    
    semaphore.wait()
    requestManager.getAllServices { [weak self] status in
      if status != ResponseStatus.success.rawValue {
        self?.showWarningAlert(message: "Application cannot get required services from the server!")
        exit(1);
      }
      
      semaphore.signal()
    }
    
    semaphore.wait()
    instantiateControllers()
  }
}

extension MainTabBarController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Critical error", message: message, type: .error).show()
  }
}
