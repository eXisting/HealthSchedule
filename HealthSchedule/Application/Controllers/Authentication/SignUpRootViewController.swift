//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

class SignUpRootViewController: UIViewController, NVActivityIndicatorViewable {
  
  // test data
  //var signUpData: Parser.JsonDictionary = ["email":"johnsmit@gmail.com", "password":"qwerty123", "first_name":"Ann", "last_name":"Yan", "birthday_at":"2019-01-31", "phone":""]
  private var rootNavigation: RootNavigationPresentable!
  
  private var mainView: MainSignUpInfoView!
  private var model: SigningUp!
  
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
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    hideKeyboardWhenTappedAround()
  }
  
  func signUp() {
    showLoader()
    
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
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardSize.height / 3
      }
    }
  }
  
  @objc private func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  private func showLoader() {
    let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
    startAnimating(size, type: .ballScaleMultiple, color: .white, minimumDisplayTime: 2, backgroundColor: UIColor.black.withAlphaComponent(0.85))
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
  }
}

extension SignUpRootViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    if isAnimating {
      stopAnimating()
    }
    
    CDAlertView(title: "Warning", message: message, type: .warning).show()
    Token.clear()
  }
}

extension SignUpRootViewController: UITextFieldDelegate {
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
}
