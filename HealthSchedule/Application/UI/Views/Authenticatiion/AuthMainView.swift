//
//  AuthMainView.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AuthMainView: UIView {
  @IBOutlet weak var logo: UIImageView!
  @IBOutlet weak var loginForm: UIStackView!
  
  @IBOutlet weak var loginField: DesignableTextField!
  @IBOutlet weak var passwordField: DesignableTextField!
  
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  func setUpViews() {
    setUpLogo()
    setUpBackground()
    setUpTextFields()
    setUpLoginButton()
  }
  
  func getFormData() -> (login: String, password: String)? {
    guard let login = loginField.text,
      let password = passwordField.text else {
        return nil
    }
    
    return (login, password)
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .scaleAspectFill
    
    insertSubview(background, at: 0)
  }
  
  private func setUpLogo() {
    logo.changeColor(to: .black)
  }
  
  private func setUpTextFields() {
    let leftPadding = loginField.imageSize + loginField.leftPadding
    let rightPadding = loginField.imageSize
    
    loginField.addLineToView(position: .bottom, color: .black, width: 1, leftPadding, rightPadding)
    passwordField.addLineToView(position: .bottom, color: .black, width: 1, leftPadding, rightPadding)
    
    loginField.attributedPlaceholder = NSAttributedString(
      string: "Username",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
    
    passwordField.attributedPlaceholder = NSAttributedString(
      string: "Password",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
  }
  
  private func setUpLoginButton() {
    signInButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    signInButton.roundCorners(by: signInButton.frame.size.height / 1.5)
  }
}
