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
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .scaleAspectFill
    BlurHandler.performBlurOn(background, blurPercent: 9)
    
    insertSubview(background, at: 0)
  }
  
  private func setUpLogo() {
    logo.changeColor(to: .black)
  }
  
  private func setUpTextFields() {
    loginField.addLineToView(position: .bottom, color: .white, width: 1)
    passwordField.addLineToView(position: .bottom, color: .white, width: 1)
    
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
    signInButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    signInButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
  }
}
