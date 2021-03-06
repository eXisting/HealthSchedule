//
//  BaseProfileView.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProfileView: UIView {
  
  private let profileImageView = UIImageView()
  private let tableView = AccountTableView()
  
  let datepickerView = DatePickerView()
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    
    tableView.setup(delegate: delegate, dataSource: dataSource)
  }
  
  func setImage(_ image: UIImage) {
    profileImageView.image = image
    profileImageView.roundCorners(by: profileImageView.frame.height / 2)
  }
  
  func setRefreshDelegate(delegate: RefreshingTableView) {
    tableView.refreshDelegate = delegate
  }
  
  func reloadRows(at indexPath: [IndexPath]) {
    tableView.reloadRows(at: indexPath, with: .fade)
  }
  
  private func laidOutViews() {
    addSubview(profileImageView)
    addSubview(tableView)
    
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: profileImageView, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 0.2, constant: 0).isActive = true

    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    profileImageView.image = UIImage(named: "Pictures/chooseProfile")
  }
}
