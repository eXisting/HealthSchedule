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
    let leftPadding = emailField.imageSize + emailField.leftPadding
    let rightPadding = emailField.imageSize
    
    emailField.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    passwordField.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    nameFIeld.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    phoneField.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    
    emailField.attributedPlaceholder = NSAttributedString(
      string: "E-mail",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
    
    passwordField.attributedPlaceholder = NSAttributedString(
      string: "Password",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
    
    nameFIeld.attributedPlaceholder = NSAttributedString(
      string: "Name and surname",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
    
    phoneField.attributedPlaceholder = NSAttributedString(
      string: "Phone",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .scaleAspectFill
    
    insertSubview(background, at: 0)
  }
}
