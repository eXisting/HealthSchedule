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
 
  @IBOutlet weak var userPicker: UISegmentedControl!
  @IBOutlet weak var emailField: DesignableTextField!
  @IBOutlet weak var passwordField: DesignableTextField!
  @IBOutlet weak var nameFIeld: DesignableTextField!
  @IBOutlet weak var phoneField: DesignableTextField!
  @IBOutlet weak var datePickerField: UITextField!
  
  @IBOutlet weak var nextButton: UIButton!
  
  func setupViews() {
    setUpUserPicker()
    setUpBackground()
    setUpTextFields()
    setUpNextButton()
  }
  
  private func setUpTextFields() {
    let leftPadding = emailField.imageSize + emailField.leftPadding
    let rightPadding = emailField.imageSize
    
    emailField.borderStyle = .none
    passwordField.borderStyle = .none
    nameFIeld.borderStyle = .none
    phoneField.borderStyle = .none
    datePickerField.borderStyle = .none

    emailField.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    passwordField.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    nameFIeld.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    phoneField.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding, rightPadding)
    
    let dateMargins = datePickerField.frame.width / 5
    datePickerField.addLineToView(position: .bottom, color: .lightGray, width: 1, dateMargins, dateMargins)

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
    
    datePickerField.attributedPlaceholder = NSAttributedString(
      string: "Birthday",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .scaleAspectFill
    
    insertSubview(background, at: 0)
  }
  
  private func setUpNextButton() {
    setNextButtonVisible(false)
    nextButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    nextButton.roundCorners(by: nextButton.frame.size.height / 2)
  }
  
  private func setUpUserPicker() {
    userPicker.tintColor = UIColor.black.withAlphaComponent(0.8)
    
    let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    userPicker.setTitleTextAttributes(titleTextAttributes, for: .selected)
    
    userPicker.setTitle(UserTypeName.client.rawValue, forSegmentAt: UserType.client.rawValue - 1)
    userPicker.setTitle(UserTypeName.provider.rawValue, forSegmentAt: UserType.provider.rawValue - 1)
    
    userPicker.selectedSegmentIndex = UserType.client.rawValue - 1
  }
}

extension MainSignUpInfoView {
  func setNextButtonVisible(_ value: Bool) {
    nextButton.isHidden = !value
  }
  
  func getNamePair() -> (firstName: String, lastName: String)? {
    guard let name = nameFIeld.text else {
      return nil
    }
    
    let namePair = name.split(separator: " ", maxSplits: 2)
    guard let firstName = namePair.first,
      let lastName = namePair.last else {
        return nil
    }
    
    if firstName == lastName {
      return nil
    }
    
    return (String(firstName), String(lastName))
  }
}
