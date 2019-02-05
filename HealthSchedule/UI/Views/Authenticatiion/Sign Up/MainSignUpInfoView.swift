//
//  MainInfoView.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class MainSignUpInfoView: UIView {
  @IBOutlet weak var signUpForm: UIStackView!
  
  @IBOutlet weak var emailField: DesignableTextField!
  @IBOutlet weak var passwordField: DesignableTextField!
  @IBOutlet weak var nameFIeld: DesignableTextField!
  @IBOutlet weak var phoneField: DesignableTextField!

  @IBOutlet weak var nextButton: UIButton!
  
  func setupViews() {
    setUpBackground()
    setUpTextFields()
  }
  
  private func setUpTextFields() {
    emailField.addLineToView(position: .bottom, color: .lightGray, width: 1)
    passwordField.addLineToView(position: .bottom, color: .lightGray, width: 1)
    nameFIeld.addLineToView(position: .bottom, color: .lightGray, width: 1)
    phoneField.addLineToView(position: .bottom, color: .lightGray, width: 1)
    
    emailField.attributedPlaceholder = NSAttributedString(
      string: "E-mail",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.white])
    
    passwordField.attributedPlaceholder = NSAttributedString(
      string: "Password",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.white])
    
    nameFIeld.attributedPlaceholder = NSAttributedString(
      string: "Name and surname",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.white])
    
    phoneField.attributedPlaceholder = NSAttributedString(
      string: "Phone",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.white])
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/signUp"))
    
    background.frame = frame
    background.contentMode = .scaleAspectFill
    BlurHandler.performBlurOn(background, blurPercent: 0)
    
    insertSubview(background, at: 0)
  }
}
