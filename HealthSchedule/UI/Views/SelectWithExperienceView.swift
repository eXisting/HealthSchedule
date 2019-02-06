//
//  SelectExperienceView.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/21/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SelectWithExperienceView: UIView {
  @IBOutlet weak var contentStack: UIStackView!
  @IBOutlet weak var experienceTextValue: UILabel!
  
  @IBAction func onSlidebarValueChanged(_ sender: UISlider) {
    experienceTextValue.text = "\(sender.value)"
  }
  
  @IBAction func onSelectCategory(_ sender: UIButton) {
    print("Sekect category clicked")
  }
}

// Remove button stuff
extension SelectWithExperienceView {
  func laidOutRemoveButton() -> UIButton {
    let removeButton = UIButton()
    removeButton.translatesAutoresizingMaskIntoConstraints = false
    contentStack.addSubview(removeButton)
    
    removeButton.backgroundImage(for: .normal)
    removeButton.setImage( UIImage.init(named: "Icons/minus"), for: .normal)
    
    NSLayoutConstraint(item: removeButton,
                       attribute: .height,
                       relatedBy: .equal,
                       toItem: contentStack,
                       attribute: .height,
                       multiplier: 0.15,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: removeButton,
                       attribute: .bottom,
                       relatedBy: .equal,
                       toItem: contentStack,
                       attribute: .bottom,
                       multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: removeButton,
                       attribute: .left,
                       relatedBy: .equal,
                       toItem: contentStack,
                       attribute: .left,
                       multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: removeButton,
                       attribute: .width,
                       relatedBy: .equal,
                       toItem: removeButton,
                       attribute: .height,
                       multiplier: 1,
                       constant: 0).isActive = true
    
    return removeButton
  }
}
