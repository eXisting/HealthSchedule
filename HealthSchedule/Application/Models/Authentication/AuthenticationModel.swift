//
//  SignInModel.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 3/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol SigningIn {
  func autoLogin(_ completion: @escaping () -> Void)
  func signIn(formData: (login: String, password: String)?, _ sender: UIButton?)
}

protocol SigningUp {
  func signUp(data: [String: Any], userType: UserType)
}

class AuthenticationModel {
  private let userRequestController: AuthenticationProviding = UserDataRequest()
  
  private var errorShowable: ErrorShowable
  private var presentResponsible: RootNavigationPresentable
  
  init(presentResponsible: RootNavigationPresentable, errorShowable: ErrorShowable) {
    self.errorShowable = errorShowable
    self.presentResponsible = presentResponsible
  }
}

extension AuthenticationModel: SigningIn {
  func autoLogin(_ completion: @escaping () -> Void) {
    RequestManager.rememberTokenFromUserDefualts()
    
    if Token.isValid() {
      // TODO: Get data from keychain and auto login
      
      // mock - just show next window
      completion()
    }
  }
  
  func signIn(formData: (login: String, password: String)?, _ sender: UIButton?) {
    sender?.isUserInteractionEnabled = false
    
    guard let formData = formData else {
      errorShowable.showWarningAlert(message: "Either login or password are not filled!")
      return
    }
    
    userRequestController.login(login: formData.login, password: formData.password) {
      [weak self] error in
      DispatchQueue.main.async {
        if let error = error {
          sender?.isUserInteractionEnabled = true
          
          self?.errorShowable.showWarningAlert(message: error)
          return
        }
        
        self?.presentResponsible.presentHome()
        sender?.isUserInteractionEnabled = true
      }
    }
  }
}

extension AuthenticationModel: SigningUp {
  func signUp(data: [String: Any], userType: UserType) {
    if !validateSignUpData(data) {
      errorShowable.showWarningAlert(message: ResponseStatus.invalidData.rawValue)
    }
    
    userRequestController.register(userType: userType, data) {
      [weak self] error in
      DispatchQueue.main.async {
        if let error = error {
          self?.errorShowable.showWarningAlert(message: error)
          return
        }
        
        self?.presentResponsible.presentHome()
      }
    }
  }
  
  private func validateSignUpData(_ data: [String: Any]) -> Bool {
    let isValid = ValidationController.shared.validate(data[UserJsonFields.firstName.rawValue]! as! String, ofType: .name) &&
      ValidationController.shared.validate(data[UserJsonFields.lastName.rawValue]! as! String, ofType: .name) &&
      ValidationController.shared.validate(data[UserJsonFields.email.rawValue]! as! String, ofType: .email) &&
      ValidationController.shared.validate(data[UserJsonFields.password.rawValue]! as! String, ofType: .password)
    
    guard let phone = data[UserJsonFields.phone.rawValue] else {
      return isValid
    }
    
    if (phone as! String).isEmpty {
      return isValid
    }
    
    return isValid && ValidationController.shared.validate(phone as! String, ofType: .phone)
  }
}
