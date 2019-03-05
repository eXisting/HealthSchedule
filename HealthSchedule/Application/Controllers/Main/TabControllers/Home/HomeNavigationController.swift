//
//  HomeNavigationController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
