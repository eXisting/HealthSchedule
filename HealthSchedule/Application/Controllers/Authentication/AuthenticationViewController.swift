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
  private let model: AuthenticationProviding = UserDataRequest()
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! AuthMainView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    rootNavigation = (self.navigationController as? RootNavigationController)
    
    mainView.setUpViews(textFieldsDelegate: self)
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
  
  @objc private func onSignInClick() {
    mainView.signInButton.isUserInteractionEnabled = false
    
    guard let formData = mainView.getFormData() else {
      showWarningAlert(message: "Either login or password are not filled!")
      return
    }
    
    model.login(login: formData.login, password: formData.password) {
      [weak self] error in
      DispatchQueue.main.async {
        if let error = error {
          self?.mainView.signInButton.isUserInteractionEnabled = true
          self?.showWarningAlert(message: error)
          return
        }

        self?.rootNavigation?.presentHome()
      }
    }
  }
  
  @objc private func onSignUpClick() {
    rootNavigation?.presentSignUpController()
  }
  
  private func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(
      for: self,
      "Warning",
      message,
      .alert)
  }
}

extension AuthenticationViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    performScreenScroll(up: true)
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    performScreenScroll(up: false)
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case mainView.loginField:
      mainView.passwordField.becomeFirstResponder()
    case mainView.passwordField:
      textField.resignFirstResponder()
      onSignInClick()
    default:
      textField.resignFirstResponder()
    }
    
    return false
  }
  
  private func performScreenScroll(up: Bool) {
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(0.35)
    var frame = self.view.frame
    let yValue = frame.origin.y + (up ? -1 : 1) * frame.height * 0.2
    
    frame.origin.y = yValue
    self.view.frame = frame
    UIView.commitAnimations()
  }
}
