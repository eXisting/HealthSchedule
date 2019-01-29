//
//  LoginViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/16/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
  
  private let signInSegueId = "signIn"
  private let signUpSequeId = "signUp"
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    
    BlurHandler.performBlurOn(backgroundImage)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    // TODO: wait until data received
    requestUser(errorHandler: validatonAlert)
    
    return false
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: pass data to next view controller
  }
  
  func requestUser(errorHandler: () -> Void) {
    // TODO: replace with text fields values
    let b = ["username":"freddy.mcglynn@example.net", "password":"secret"]
    RequestManager.signIn(authType: .client, body: b) { (user, error) in
      // TODO: store it and pass to another controlelr in case when error is nil
      print(user)
    }
  }
  
  private func validatonAlert() {
    AlertHandler.ShowAlert(
      for: self,
      "Validation",
      "Either login or password is incorrect",
      .alert)
    
    emailField.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
    passwordField.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
  }
}
