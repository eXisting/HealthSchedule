//
//  SignInModel.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 3/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignInModel {
  private let model: AuthenticationProviding = UserDataRequest()
  
  private var errorShowable: ErrorShowable
  private var presentResponsible: RootNavigationPresentable

  init(presentResponsible: RootNavigationPresentable, errorShowable: ErrorShowable) {
    self.errorShowable = errorShowable
    self.presentResponsible = presentResponsible
  }
  
  func signIn(formData: (login: String, password: String)?, _ sender: UIButton) {
    sender.isUserInteractionEnabled = false
    
    guard let formData = formData else {
      errorShowable.showWarningAlert(message: "Either login or password are not filled!")
      return
    }
    
    model.login(login: formData.login, password: formData.password) {
      [weak self] error in
      DispatchQueue.main.async {
        if let error = error {
          sender.isUserInteractionEnabled = true
          
          self?.errorShowable.showWarningAlert(message: error)
          return
        }
        
        self?.presentResponsible.presentHome()
      }
    }
  }
}
