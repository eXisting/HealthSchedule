//
//  AddressView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy

class AddressView: UIView {
  private var addressInputField: UITextField!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addressInputField = UITextField()
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(textFieldsDelegate: UITextFieldDelegate) {
    addressInputField.delegate = textFieldsDelegate
  }
  
  func setup(_ address: String) {
    addressInputField.text = address
  }
  
  func isValid() -> Bool {
    guard let text = addressInputField.text else {
      return false
    }
    
    return !text.isEmpty && text.count > 5
  }
  
  func collectData() -> String {
    return addressInputField.text!
  }

  private func laidOutViews() {
    addSubview(addressInputField)
    
    addressInputField.easy.layout([
      Width(*0.95).like(self),
      CenterX().to(self),
      Height(*0.08).like(self)
    ])
    
    NSLayoutConstraint(
      item: addressInputField,
      attribute: .top,
      relatedBy: .equal,
      toItem: self.compatibleSafeAreaLayoutGuide,
      attribute: .top,
      multiplier: 1,
      constant: 8
    ).isActive = true
  }

  private func customizeViews() {
    backgroundColor = .white
    
    addressInputField.placeholder = "Your major address"
    addressInputField.clearButtonMode = .whileEditing
    addressInputField.setIcon(UIImage(named: "Icons/location")!)
    addressInputField.borderStyle = .roundedRect
  }
}
