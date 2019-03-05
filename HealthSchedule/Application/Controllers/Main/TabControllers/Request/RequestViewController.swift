//
//  RequestViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, SetupableTabBarItem {
  private let titleName = "Requests"
  
  override func loadView() {
    super.loadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func setupTabBarItem() {
    tabBarItem.title  = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/requests")
    tabBarItem.image = UIImage(named: "TabBarIcons/requests")
  }
}
