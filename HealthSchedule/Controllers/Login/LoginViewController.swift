//
//  LoginViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/16/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  private let signInSegueId = "signIn"
  private let signUpSequeId = "signUp"
  
  private let opaqueRed = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
  
  let n = "1"
  let p = "2"
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: pass data to next view controller
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == signInSegueId && !validateFields() {
      AlertHandler.ShowAlert(
        for: self,
        "Validation",
        "Either login or password is incorrect",
        .alert)
      
      emailField.backgroundColor = opaqueRed
      passwordField.backgroundColor = opaqueRed
      
      return false
    }
    
    return true
  }
  
  func validateFields() -> Bool {
    // TODO: Call API instead
    return emailField.text == n && passwordField.text == p
  }
  
}
