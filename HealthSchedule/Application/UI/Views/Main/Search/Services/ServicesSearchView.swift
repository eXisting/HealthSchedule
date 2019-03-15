//
//  ServicesSearchView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ServicesSearchView: UIView {
  private let noDataView = NoDataView()
  private let tableView = UITableView()
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    
    noDataView.setup("There is nothng to display...")
    tableView.delegate = delegate
    tableView.dataSource = dataSource
    
    backgroundColor = .white
  }
  
  func toggleViews(isDataPresent: Bool) {
    noDataView.isHidden = isDataPresent
    tableView.isHidden = !isDataPresent
  }
  
  private func laidOutViews() {
    addSubview(tableView)
    addSubview(noDataView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    noDataView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: noDataView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: noDataView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: noDataView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: noDataView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    tableView.isHidden = true
  }
}
