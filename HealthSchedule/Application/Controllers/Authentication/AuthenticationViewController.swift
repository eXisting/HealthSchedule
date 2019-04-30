//
//  LoginViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/16/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

class AuthenticationViewController: UIViewController, NVActivityIndicatorViewable {
  private var rootNavigation: RootNavigationPresentable!
  
  private var mainView: AuthMainView!
  private var model: SigningIn!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    rootNavigation = (self.navigationController as! RootNavigationController)
    model = AuthenticationModel(presentResponsible: rootNavigation, errorShowable: self)
  }
  
  override func loadView() {
    super.loadView()
    
    mainView = (view as! AuthMainView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    autoLogin()
    
    mainView.setUpViews(textFieldsDelegate: self)
    mainView.signInButton.addTarget(self, action: #selector(onSignInClick), for: .touchDown)
    mainView.signUpButton.addTarget(self, action: #selector(onSignUpClick), for: .touchDown)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    hideKeyboardWhenTappedAround()
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
    showLoader()
    
    mainView.signInButton?.isUserInteractionEnabled = false
    
    model.signIn(formData: mainView.getFormData()) { [weak self] response in
      DispatchQueue.main.async {
        self?.stopAnimating()
      }
      
      if response == ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.rootNavigation.presentHome()
          self?.mainView.signInButton?.isUserInteractionEnabled = true
        }
        return
      }
      
      DispatchQueue.main.async {
        self?.showWarningAlert(message: response)
        self?.mainView.signInButton?.isUserInteractionEnabled = true
      }
    }
  }
  
  @objc private func onSignUpClick() {
    rootNavigation.presentSignUpController()
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardSize.height / 2
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  private func autoLogin() {
    model.autoLogin { [weak self] response in
      if response == ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.rootNavigation.presentHome()
        }
        return
      }
      
      if response == UserDefaultsKeys.logutTriggered.rawValue
        || response == UserDefaultsKeys.applicationLaunchedOnce.rawValue {
        return
      }
      
      DispatchQueue.main.async {
        self?.showWarningAlert(message: response)
      }
    }
  }
  
  private func showLoader() {
    let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
    startAnimating(size, type: .ballScaleMultiple, color: .white, minimumDisplayTime: 2, backgroundColor: UIColor.black.withAlphaComponent(0.85))
  }
}

extension AuthenticationViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension AuthenticationViewController: UITextFieldDelegate {
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
}
