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
  
  private func laidOutViews() {
    addSubview(headerView)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    headerView.pin(to: self)
  }
  
  private func customizeViews() {
    headerView.image = UIImage(named: "Pictures/header")
    headerView.contentMode = .scaleAspectFill
  }
}
