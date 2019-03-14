//
//  RootNavigationController.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ErrorShowable {
  func showWarningAlert(message: String)
}

protocol RootNavigationPresentable {
  func presentHome()
  func presentSignUpController()
  func presentProviderDetailsController()
}

class RootNavigationController: UINavigationController {
  private(set) var signUpStoryboard: UIStoryboard!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    signUpStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
  }
  
  @objc func popNavigationStackOnLogout() {
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sessionToken.rawValue)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sessionExpires.rawValue)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userUniqueId.rawValue)
    
    popToRootViewController(animated: true)
    dismiss(animated: true)
  }
}

extension RootNavigationController: RootNavigationPresentable {
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
