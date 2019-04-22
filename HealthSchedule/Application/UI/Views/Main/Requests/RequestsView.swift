//
//  RequestsView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/22/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestsView: UIView {
  private let headerView = NavigationHoverHeaderView()
  private let searchButton = UIButton()
  
  let tableView = RequestListTableView()
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, refreshDelegate: RefreshingTableView) {
    laidOutViews()
    
    headerView.setup()
    tableView.setup(delegate: delegate, dataSource: dataSource, refreshDelegate: refreshDelegate)
  }
  
  private func laidOutViews() {
    addSubview(tableView)
    addSubview(headerView)
    
    headerView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
}
