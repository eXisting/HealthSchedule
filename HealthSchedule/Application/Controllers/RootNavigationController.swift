//
//  RootNavigationController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
  private(set) var signUpStoryboard: UIStoryboard!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    signUpStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
  }
  
  func presentHome() {
    let tabController = MainTabBarController()
    present(tabController, animated: true, completion: nil)
  }
  
  func presentSignUpController() {
    let controller = signUpStoryboard.instantiateInitialViewController() as! SignUpRootViewController
    pushViewController(controller, animated: true)
  }
  
  func presentProviderDetailsController() {
    let controller = signUpStoryboard.instantiateViewController(withIdentifier: "ProviderSignUp") as! ProviderSignUpViewController
    pushViewController(controller, animated: true)
  }
}
