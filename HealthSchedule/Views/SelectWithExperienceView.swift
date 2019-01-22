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
  
  class func instanceFromNib() -> UIView {
    return UINib(nibName: "SelectWithExperienceView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }
}

extension UIView {
  func expandPutViewTo(_ container: UIView!) {
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.frame = container.frame;
    container.addSubview(self);
    NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
  }
}
