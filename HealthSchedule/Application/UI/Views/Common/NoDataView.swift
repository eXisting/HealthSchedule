//
//  NoDataView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class NoDataView: UIView {
  private let textMessage = UILabel()
  
  func setup(_ text: String) {
    textMessage.text = text
    laidOutViews()
    customizeViews()
  }
  
  private func laidOutViews() {
    addSubview(textMessage)
    textMessage.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: textMessage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: textMessage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: textMessage, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: textMessage, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    textMessage.adjustsFontSizeToFitWidth = true
    textMessage.textAlignment = .center
  }
}
