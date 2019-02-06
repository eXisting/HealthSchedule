//
//  SignUpViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/17/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SignUpRootViewController: UIViewController {
  
  var signUpData: Parser.JsonDictionary = [:]
  var mainView: MainSignUpInfoView!
  
  override func loadView() {
    super.loadView()
    self.navigationController?.title = "SIGN UP"
    
    mainView = (view as! MainSignUpInfoView)
    mainView.setupViews()
    mainView.nextButton.addTarget(self, action: #selector(onNextClick), for: .touchDown)
    
    [mainView.emailField, mainView.passwordField, mainView.nameFIeld]
      .forEach({ $0.addTarget(self, action: #selector(collectData), for: .editingChanged) })
  }
  
  @objc func onNextClick() {
    if validateData() {
      let additionalController = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalSignUp") as! AdditionalInfoSignUpController
      
      self.navigationController?.pushViewController(additionalController, animated: true)
    } else {
      // TODO: Alert error
    }
  }
  
  @objc func collectData(_ textField: UITextField) {
    guard let namePair = mainView.getNamePair() else { return }
    guard let email = mainView.emailField.text else { return }
    guard let password = mainView.passwordField.text else { return }
    
    if namePair.firstName.isEmpty || namePair.lastName.isEmpty ||
      email.isEmpty || password.isEmpty {
      mainView.setNextButtonVisible(false)
      return
    }
    
    signUpData[UserJsonFields.firstName.rawValue] = namePair.firstName
    signUpData[UserJsonFields.lastName.rawValue] = namePair.lastName
    signUpData[UserJsonFields.email.rawValue] = email
    signUpData[UserJsonFields.password.rawValue] = password

    if let phone = mainView.phoneField.text {
      signUpData[UserJsonFields.phone.rawValue] = phone
    }
    
    mainView.setNextButtonVisible(true)
  }
  
  private func validateData() -> Bool {
    let isValid = ValidationController.shared.validate(signUpData[UserJsonFields.firstName.rawValue]!, ofType: .name) &&
      ValidationController.shared.validate(signUpData[UserJsonFields.lastName.rawValue]!, ofType: .name) &&
      ValidationController.shared.validate(signUpData[UserJsonFields.email.rawValue]!, ofType: .email) &&
      ValidationController.shared.validate(signUpData[UserJsonFields.password.rawValue]!, ofType: .password)

    guard let phone = signUpData[UserJsonFields.phone.rawValue] else {
      return isValid
    }
    
    if phone.isEmpty {
      return isValid
    }
    
    return isValid && ValidationController.shared.validate(phone, ofType: .phone)
  }
}
