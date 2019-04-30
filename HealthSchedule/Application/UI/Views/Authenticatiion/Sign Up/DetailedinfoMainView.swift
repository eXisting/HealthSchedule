//
//  DetailedinfoMainView.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/6/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderInfoView: UIView {
  
  @IBOutlet weak var textInfo: UITextView!
  @IBOutlet weak var verifyImage: UIImageView!
  @IBOutlet weak var nextButton: UIButton!
  
  func setupViews() {
    setUpBackground()
    setUpTextFields()
    setUpImageViews()
    setUpButtons()
  }
  
  func setNextButtonVisible(_ value: Bool) {
    nextButton.isHidden = !value
  }
  
  private func setUpTextFields() {
    textInfo.setContentOffset(CGPoint.zero, animated: false)
  }
  
  private func setUpImageViews() {
    verifyImage.image = UIImage(named: "Icons/diploma")
  }
  
  private func setUpBackground() {
    let background = UIImageView(image: UIImage(named: "Backgrounds/auth"))
    
    background.frame = frame
    background.contentMode = .scaleAspectFill
    background.clipsToBounds = true
    insertSubview(background, at: 0)
  }
  
  private func setUpButtons() {
    //setNextButtonVisible(false)
    
    nextButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    nextButton.roundCorners(by: nextButton.frame.size.height / 2)
  }
}
