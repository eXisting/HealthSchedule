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
  private let signUpSequeId = "signUpStart"
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  private var isLoginSucceded = false
  
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
    if identifier == signUpSequeId {
      signUp(errorHandler: validatonAlert)
      return false
    }
    requestUser(errorHandler: validatonAlert)
    
    return isLoginSucceded
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: pass data to next view controller
  }
  
  func requestUser(errorHandler: @escaping (Error?) -> Void) {
    // TODO: replace with text fields values
    let b = ["username":"keebler.macey@example.com", "password":"secret"]
    RequestManager.signIn(authType: .client, body: b) { [weak self] (userData, error) in
      // TODO: store it and pass to another controlelr in case when error is nil
      guard let user = userData as? User else {
        errorHandler(error)
        return
      }
      
      print(user)
      self?.isLoginSucceded = true
    }
  }
  
  func signUp(errorHandler: @escaping (Error?) -> Void) {
//    let body = [
//      "email":"johny1234@gmail.com",
//      "phone":"123453124512",
//      "password":"qwerty",
//      "first_name":"Magic name2",
//      "last_name":"hehdasdase",
//      "photo":"",
//      "city_id":"2",
//      "birthday":"1999-11-11 00:00:00"
//    ]
    
    let body = [
      "email":"johny1234@gmail.com",
      "phone":"123453124512",
      "password":"qwerty",
      "first_name":"Magic name2",
      "last_name":"hehdasdase",
      "photo":"",
      "city_id":"2",
      "birthday":"1999-11-11 00:00:00",
      "address":"cudo street",
      "professions":"",
      "verifies":""
    ]

    
    RequestManager.signUp(authType: .client, body: body) { [weak self] (userData, error) in
      // TODO: store it and pass to another controlelr in case when error is nil
      guard let user = userData as? User else {
        errorHandler(error)
        return
      }
      
      print(user)
    }
  }
  
  private func validatonAlert(_ error: Error?) {
    AlertHandler.ShowAlert(
      for: self,
      "Validation",
      error?.localizedDescription ?? "Either login or password is incorrect!",
      .alert)
    
    emailField.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
    passwordField.backgroundColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
  }
}
