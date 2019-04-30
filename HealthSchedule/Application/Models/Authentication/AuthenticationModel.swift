//
//  SignInModel.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 3/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol SigningIn {
  func autoLogin(_ completion: @escaping (String) -> Void)
  func signIn(formData: (login: String, password: String)?, _ completion: @escaping (String) -> Void)
}

protocol SigningUp {
  func signUp(data: Parser.JsonDictionary, userType: UserType)
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
  func autoLogin(_ completion: @escaping (String) -> Void) {
    RequestManager.rememberTokenFromUserDefualts()
    
    if Token.isValid() {
      // TODO: Refresh token
      
      // mock - just show next window
      completion(ResponseStatus.success.rawValue)
      return
    }
    
    let isUserTriggeredLogout = UserDefaults.standard.bool(forKey: UserDefaultsKeys.logutTriggered.rawValue)
    let isAppRunBefore = UserDefaults.standard.bool(forKey: UserDefaultsKeys.applicationLaunchedOnce.rawValue)
    
    // if user has initiated - do nothing
    if isUserTriggeredLogout && isAppRunBefore {
      completion(UserDefaultsKeys.logutTriggered.rawValue)
      return
    }
    
    // if app has been launched for the first time - do nothing
    if !isUserTriggeredLogout && !isAppRunBefore {
      completion(UserDefaultsKeys.applicationLaunchedOnce.rawValue)
      return
    }
    
    completion(ResponseStatus.tokenExpired.rawValue)
  }
  
  func signIn(formData: (login: String, password: String)?, _ completion: @escaping (String) -> Void) {
    guard let formData = formData else {
      errorShowable.showWarningAlert(message: "Either login or password are not filled!")
      return
    }
    
    userRequestController.login(login: formData.login, password: formData.password) { response in
      if response != ResponseStatus.success.rawValue {
        completion(response)
        return
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}

extension AuthenticationModel: SigningUp {
  func signUp(data: Parser.JsonDictionary, userType: UserType) {
    if !validateSignUpData(data) {
      errorShowable.showWarningAlert(message: ResponseStatus.invalidData.rawValue)
    }
    
    userRequestController.register(userType: userType, data) { [weak self] response in
      DispatchQueue.main.async {
        if response != ResponseStatus.success.rawValue {
          self?.errorShowable.showWarningAlert(message: response)
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
