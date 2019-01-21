//
//  SelectExperienceView.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/21/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SelectExperienceView: UIView {
  
  @IBOutlet weak var contentStack: UIStackView!
  
  private let CURRENT_CONTENT_XIB_NAME = "SelectWithExperienceView"
  
  @IBOutlet weak var experienceTextValue: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed(CURRENT_CONTENT_XIB_NAME, owner: self, options: nil)
    contentStack.expandViewTo(self)
  }
  
  @IBAction func onSlidebarValueChanged(_ sender: UISlider) {
  
  }
  
  @IBAction func onSelectCategory(_ sender: UIButton) {
    
  }
}

extension UIStackView {
  func expandViewTo(_ container: UIView!) {
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.frame = container.frame;
    container.addSubview(self);
    NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
  }
}
