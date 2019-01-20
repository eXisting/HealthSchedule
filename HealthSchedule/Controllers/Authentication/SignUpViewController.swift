//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  private var rootNaviationController: RootNavigationController?
  
  // MARK: - Outlets
  
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passowrdVerifyField: UITextField!
  
  @IBOutlet weak var birthdayPicker: UIDatePicker!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    rootNaviationController = self.navigationController as? RootNavigationController
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    // TODO: Validation
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: pass data to next view controller
  }
}
