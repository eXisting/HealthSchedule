//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignUpRootViewController: UIViewController {
  
  // test data
  //var signUpData: Parser.JsonDictionary = ["email":"johnsmit@gmail.com", "password":"qwerty123", "first_name":"Ann", "last_name":"Yan", "birthday_at":"2019-01-31", "phone":""]
  private var rootNavigation: RootNavigationPresentable!
  
  private var mainView: MainSignUpInfoView!
  private var model: AuthenticationModel!
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! MainSignUpInfoView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    rootNavigation = (self.navigationController as! RootNavigationController)
    model = AuthenticationModel(presentResponsible: rootNavigation, errorShowable: self)
    
    mainView.setupViews(textFieldsDelegate: self)
    mainView.addTargets()
    
    mainView.nextButton.addTarget(self, action: #selector(onNextClick), for: .touchDown)
  }
  
  func signUp() {
    model.signUp(data: mainView.collectedData, userType: mainView.userType)
  }
  
  // MARK: - Callbacks
  
  @objc private func onNextClick() {
    if mainView.userType == .provider {
      rootNavigation?.presentProviderDetailsController()
      return
    }
    
    signUp()
  }
}

extension SignUpRootViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(
      for: self,
      "Warning",
      message,
      .alert)
  }
}

extension SignUpRootViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    performScreenScroll(up: true)
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    performScreenScroll(up: false)
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case mainView.nameFIeld:
      mainView.emailField.becomeFirstResponder()
    case mainView.emailField:
      mainView.passwordField.becomeFirstResponder()
    case mainView.passwordField:
      mainView.phoneField.becomeFirstResponder()
    case mainView.phoneField:
      textField.resignFirstResponder()
    default:
      textField.resignFirstResponder()
    }
    
    return false
  }
  
  private func performScreenScroll(up: Bool) {
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(0.35)
    var frame = self.view.frame
    let yValue = frame.origin.y + (up ? -1 : 1) * frame.height * 0.1
    
    frame.origin.y = yValue
    self.view.frame = frame
    UIView.commitAnimations()
  }
}
