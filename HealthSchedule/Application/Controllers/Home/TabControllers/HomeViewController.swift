//
//  FeedViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, SetupableTabBarItem {
  private let titleName = "Home"
  
  private let mainView = HomeView()
  
  override func loadView() {
    super.loadView()
    
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = titleName
    
    mainView.setup()
  }
  
  func setupTabBarItem() {
    tabBarItem.title = titleName
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/home")
    tabBarItem.image = UIImage(named: "TabBarIcons/home")
  }
}
