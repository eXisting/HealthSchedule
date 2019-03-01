//
//  AccountViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
  private let titleName = "Account"
  
  private var mainView: ProfileView!
  
  override func loadView() {
    super.loadView()
    
    mainView = ProfileView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.title = titleName
    title = titleName
    
    mainView.setup()
    
    tabBarItem.selectedImage = UIImage(named: "TabBarIcons/account")
    tabBarItem.image = UIImage(named: "TabBarIcons/account")
    view.backgroundColor = .white
  }
  
  func populate() {
    print("Populating..")
  }
}
