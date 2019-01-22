//
//  SelectExperienceView.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/21/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

typealias ConstraintValues = (multiplier: CGFloat, constant: CGFloat, relation: NSLayoutConstraint.Relation)

class SelectWithExperienceView: UIView {
  @IBOutlet weak var contentStack: UIStackView!
  @IBOutlet weak var experienceTextValue: UILabel!
  
  @IBAction func onSlidebarValueChanged(_ sender: UISlider) {
    experienceTextValue.text = "\(sender.value)"
  }
  
  @IBAction func onSelectCategory(_ sender: UIButton) {
    print("Sekect category clicked")
  }
  
  class func instanceFromNib() -> UIView {
    return UINib(nibName: "SelectWithExperienceView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }
}
