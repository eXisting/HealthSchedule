//
//  TransparentHeaderView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class NavigationHoverHeaderView: UIView {
  private let headerView = UIImageView()
  
  func setup() {
    laidOutViews()
    customizeViews()
  }
  
  func laidOutViews() {
    addSubview(headerView)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    headerView.image = UIImage(named: "Pictures/header")
    headerView.contentMode = .scaleAspectFill
  }
}
