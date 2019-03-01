//
//  HomeView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeView: UIView {
  private let headerView = UIView()
  private let infolabel = UILabel()
  
  private let searchButton = UIButton()
  
  func setup() {
    laidOutViews()
    customizeViews()
  }
  
  func laidOutViews() {
    addSubview(headerView)
    addSubview(searchButton)
    headerView.addSubview(infolabel)
    
    headerView.translatesAutoresizingMaskIntoConstraints = false
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    infolabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.15, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

    NSLayoutConstraint(item: infolabel, attribute: .left, relatedBy: .equal, toItem: headerView, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: infolabel, attribute: .bottom, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: infolabel, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: infolabel, attribute: .height, relatedBy: .equal, toItem: headerView, attribute: .height, multiplier: 0.4, constant: 0).isActive = true

    NSLayoutConstraint(item: searchButton, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.6, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    headerView.backgroundColor = .blue
    infolabel.text = "Select appropriate params"
    infolabel.textAlignment = .left
    
    searchButton.setTitle("Find", for: .normal)
  }
}
