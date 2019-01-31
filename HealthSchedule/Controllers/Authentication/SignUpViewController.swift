//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  private var rootNaviationController: RootAuthNavigationController?
  
  // MARK: - Outlets
  
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passowrdVerifyField: UITextField!
  
  @IBOutlet weak var birthdayPicker: UIDatePicker!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    rootNaviationController = self.navigationController as? RootAuthNavigationController
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    let redColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.5)
    var isValid = true
    
    if !ValidationController.shared.validate(phoneField.text!, ofType: .phone) {
      isValid = false
      phoneField.backgroundColor = redColor
    }
    
    if !ValidationController.shared.validate(emailField.text!, ofType: .email) {
      emailField.backgroundColor = redColor
      isValid = false
    }
    
    if !ValidationController.shared.confirmPassword(passwordField.text!, passowrdVerifyField.text!) {
      passwordField.backgroundColor = redColor
      passowrdVerifyField.backgroundColor = redColor
      isValid = false
    }
    
    //return isValid
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: pass data to next view controller
  }
}
