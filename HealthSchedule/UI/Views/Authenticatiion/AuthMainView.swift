//
//  AuthMainView.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AuthMainView: UIView {
  
  @IBOutlet weak var loginField: DesignableTextField!
  @IBOutlet weak var passwordField: DesignableTextField!
  
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  func setUpViews() {
    setUpBackground()
    setUpTextFields()
    setUpLoginButton()
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .center
    background.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    BlurHandler.performBlurOn(background, blurPercent: 9)
    
    insertSubview(background, at: 0)
  }
  
  private func setUpTextFields() {
    loginField.addLineToView(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1)
    loginField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.strokeColor: UIColor.white])
    passwordField.addLineToView(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 1)
  }
  
  private func setUpLoginButton() {
    signInButton.backgroundColor = .gray
    signInButton.roundCorners(by: signInButton.frame.size.height / 1.5)
    signInButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    signInButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
  }
}
