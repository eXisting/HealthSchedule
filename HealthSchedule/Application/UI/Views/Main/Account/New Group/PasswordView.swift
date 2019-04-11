//
//  PasswordView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class PasswordView: UIView {
  private let container = UIStackView()
  
  private let oldPasswordField = UITextField()
  private let newPasswordField = UITextField()
  private let newPasswordConfirmField = UITextField()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(textFieldsDelegate: UITextFieldDelegate) {
    oldPasswordField.delegate = textFieldsDelegate
    newPasswordField.delegate = textFieldsDelegate
    newPasswordConfirmField.delegate = textFieldsDelegate
  }
  
  func collectData() -> [String: String] {
    var data: [String: String] = [:]
    
    data[UserJsonFields.oldPassword.rawValue] = oldPasswordField.text
    data[UserJsonFields.newPassword.rawValue] = newPasswordField.text
    data[UserJsonFields.confirmPassword.rawValue] = newPasswordConfirmField.text

    return data
  }
  
  private func laidOutViews() {
    addSubview(container)
    container.addArrangedSubview(oldPasswordField)
    container.addArrangedSubview(newPasswordField)
    container.addArrangedSubview(newPasswordConfirmField)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: -8).isActive = true
    NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.35, constant: 8).isActive = true
    NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    container.axis = .vertical
    container.distribution = .fillEqually
    container.alignment = .fill
    container.spacing = 5.0
    
    oldPasswordField.placeholder = "Old password"
    newPasswordField.placeholder = "New password"
    newPasswordConfirmField.placeholder = "Password confirm"
    
    oldPasswordField.clearButtonMode = .whileEditing
    newPasswordField.clearButtonMode = .whileEditing
    newPasswordConfirmField.clearButtonMode = .whileEditing

    oldPasswordField.setIcon(UIImage(named: "Icons/key")!)
    newPasswordField.setIcon(UIImage(named: "Icons/password")!)
    newPasswordConfirmField.setIcon(UIImage(named: "Icons/password")!)
    
    oldPasswordField.borderStyle = .roundedRect
    newPasswordField.borderStyle = .roundedRect
    newPasswordConfirmField.borderStyle = .roundedRect
    
    oldPasswordField.isSecureTextEntry = true
    newPasswordField.isSecureTextEntry = true
    newPasswordConfirmField.isSecureTextEntry = true
  }
}
