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
    
    setUpLoginButton()
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .center
    BlurHandler.performBlurOn(background, blurPercent: 9)
    
    insertSubview(background, at: 0)
  }
  
  private func setUpTextFields() {
    
  }
  
  private func setUpLoginButton() {
    signInButton.backgroundColor = .gray
    signInButton.roundButton(by: CGSize(width: 32, height: 32))
  }
}
