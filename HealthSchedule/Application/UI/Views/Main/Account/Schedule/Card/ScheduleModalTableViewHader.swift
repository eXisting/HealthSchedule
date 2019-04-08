//
//  ExpandableTextHeader.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ExandableHeaderViewDelegate {
  func toogleExpand(for header: UITableViewHeaderFooterView, section: Int)
}

class ScheduleModalTableViewHader: UITableViewHeaderFooterView {
  private let displayingLabel = UILabel()
  private let placholderLabel = UILabel()
  
  var collapseDelegate: ExandableHeaderViewDelegate!
  var data: ExpandableSectionData!
  
  override func setNeedsLayout() {
    super.setNeedsLayout()
    if let data = data {
      displayingLabel.text = data.displayData      
    }
  }
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectHeader)))
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setDisplayInfo(_ placeholder: String, data: String) {
    displayingLabel.text = data
    placholderLabel.text = placeholder
  }
  
  private func laidOutViews() {
    addSubview(placholderLabel)
    addSubview(displayingLabel)
    
    placholderLabel.translatesAutoresizingMaskIntoConstraints = false
    displayingLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: placholderLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 8).isActive = true
    NSLayoutConstraint(item: placholderLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: placholderLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: placholderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.4, constant: 0).isActive = true
    
    NSLayoutConstraint(item: displayingLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -8).isActive = true
    NSLayoutConstraint(item: displayingLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: displayingLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: displayingLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.4, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    placholderLabel.textAlignment = .left
    displayingLabel.textAlignment = .right
    
    placholderLabel.textColor = .black
    displayingLabel.textColor = .orange
  }
  
  @objc private func onSelectHeader(recognizer: UITapGestureRecognizer) {
    let header = recognizer.view as! ScheduleModalTableViewHader
    collapseDelegate.toogleExpand(for: header, section: header.data.section)
  }
}
