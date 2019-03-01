//
//  FeedViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
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
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/home")
    tabBarItem.image = UIImage(named: "TabBarIcons/home")
    view.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.title = titleName
  }
}
