//
//  HistoryViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, SetupableTabBarItem {
  private let titleName = "History"
  
  override func loadView() {
    super.loadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func setupTabBarItem() {
    tabBarItem.title  = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/history")
    tabBarItem.image = UIImage(named: "TabBarIcons/history")
  }
}
