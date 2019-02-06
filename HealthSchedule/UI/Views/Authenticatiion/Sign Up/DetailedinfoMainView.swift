//
//  DetailedinfoMainView.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/6/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class DetailedinfoMainView: UIView {
  @IBOutlet weak var userPicker: UISegmentedControl!
  @IBOutlet weak var cityPicker: DesignableTextField!
  @IBOutlet weak var birthdayPicker: UIDatePicker!
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  func setupViews() {
    setUpUserPicker()
    setUpBackground()
    setUpTextFields()
    setUpButtons()
  }
  
  private func setUpTextFields() {
    let leftPadding = cityPicker.imageSize + cityPicker.leftPadding
    
    cityPicker.borderStyle = .none
    
    cityPicker.addLineToView(position: .bottom, color: .lightGray, width: 1, leftPadding)
    
    cityPicker.attributedPlaceholder = NSAttributedString(
      string: "City",
      attributes: [NSAttributedString.Key.strokeColor: UIColor.black])
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .scaleAspectFill
    
    insertSubview(background, at: 0)
  }
  
  private func setUpUserPicker() {
    userPicker.tintColor = UIColor.black.withAlphaComponent(0.8)
    
    let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    userPicker.setTitleTextAttributes(titleTextAttributes, for: .selected)
    
    userPicker.setTitle(UserTypeName.client.rawValue, forSegmentAt: UserType.client.rawValue - 1)
    userPicker.setTitle(UserTypeName.provider.rawValue, forSegmentAt: UserType.provider.rawValue - 1)
    
    userPicker.selectedSegmentIndex = UserType.client.rawValue - 1
    
  }
  
  private func setUpButtons() {
    setNextButtonVisible(false)
    setDoneButtonVisible(false)
    
    doneButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    doneButton.roundCorners(by: nextButton.frame.size.height / 1.5)
    
    nextButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    nextButton.roundCorners(by: nextButton.frame.size.height / 2)
  }
}

extension DetailedinfoMainView {
  func setNextButtonVisible(_ value: Bool) {
    nextButton.isHidden = !value
  }
  
  func setDoneButtonVisible(_ value: Bool) {
    doneButton.isHidden = !value
  }
  
  func isCityFieldEmpty() -> Bool {
    guard let _ = cityPicker.text?.isEmpty else {
      return false
    }
    
    return true
  }
}
