//
//  LoginViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/16/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
  private var rootNavigation: RootNavigationController?
  private var mainView: AuthMainView!
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! AuthMainView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    rootNavigation = (self.navigationController as? RootNavigationController)
    
    mainView.setUpViews()
    mainView.signInButton.addTarget(self, action: #selector(onSignInClick), for: .touchDown)
    mainView.signUpButton.addTarget(self, action: #selector(onSignUpClick), for: .touchDown)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  @objc func onSignInClick() {
    let login = mainView.loginField.text!
    let password = mainView.passwordField.text!
    UserManager.shared.login(login: login, password: password) {
      [weak self] error in
      DispatchQueue.main.async {
        if let error = error {
          AlertHandler.ShowAlert(
            for: self!,
            "Warning",
            error,
            .alert)

          return
        }

        self?.rootNavigation?.presentHome()
      }
    }
  }
  
  @objc func onSignUpClick() {
    rootNavigation?.presentSignUpController()
  }
}
