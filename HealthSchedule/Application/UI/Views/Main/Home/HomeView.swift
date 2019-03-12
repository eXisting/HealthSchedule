//
//  HomeView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeView: UIView {
  private let tableView = HomeTableView()
  private let noDataView = NoDataView()
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    
    noDataView.setup("Sections should be here")
    tableView.setup(delegate: delegate, dataSource: dataSource)
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
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
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
