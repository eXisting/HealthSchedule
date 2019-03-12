//
//  SignInModel.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 3/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AuthenticationModel {
  private let userRequestController: AuthenticationProviding = UserDataRequest()
  
  private var errorShowable: ErrorShowable
  private var presentResponsible: RootNavigationPresentable
  
  init(presentResponsible: RootNavigationPresentable, errorShowable: ErrorShowable) {
    self.errorShowable = errorShowable
    self.presentResponsible = presentResponsible
  }
  
  func autoLogin(_ completion: @escaping () -> Void) {
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
      }
    }
  }
}
