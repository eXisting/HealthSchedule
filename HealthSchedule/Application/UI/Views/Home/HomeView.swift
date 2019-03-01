//
//  HomeView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeView: UIView {
  private let navigatonHoverHeader = NavigationHoverHeaderView()
  
  private let searchButton = UIButton()
  
  func setup() {
    laidOutViews()
    customizeViews()
  }
  
  func laidOutViews() {
    addSubview(navigatonHoverHeader)
    addSubview(searchButton)
    
    navigatonHoverHeader.setup()
    
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    navigatonHoverHeader.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: navigatonHoverHeader, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: navigatonHoverHeader, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: navigatonHoverHeader, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: navigatonHoverHeader, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: searchButton, attribute: .top, relatedBy: .equal, toItem: navigatonHoverHeader, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.6, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    searchButton.setTitle("Find", for: .normal)
    searchButton.tintColor = .blue
  }
}
