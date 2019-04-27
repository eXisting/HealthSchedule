//
//  HomeView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchView: UIView {
  private let tableView = SearchTableView()
  
  private let headerView = NavigationHoverHeaderView()
  private let searchButton = UIButton(type: UIButton.ButtonType.roundedRect)
  
  var searchDelegate: SearchResponsible!

  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, searchDelegate: SearchResponsible) {
    self.searchDelegate = searchDelegate

    laidOutViews()
    customizeViews()
    
    headerView.setup()
    tableView.setup(delegate: delegate, dataSource: dataSource)
    
    searchButton.addTarget(self, action: #selector(onSearchButtonClick), for: .touchUpInside)
  }
  
  func reloadSections(_ at: IndexSet, _ animation: UITableView.RowAnimation) {
    tableView.reloadSections(at, with: animation)
  }
  
  @objc private func onSearchButtonClick() {
    searchDelegate?.startSearch()
  }
  
  private func laidOutViews() {
    addSubview(tableView)
    addSubview(headerView)
    addSubview(searchButton)

    headerView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    searchButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: searchButton, attribute: .top, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: searchButton, attribute: .bottom, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.65, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.05, constant: 0).isActive = true
    
    NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {    
    searchButton.roundBorder()
    searchButton.setTitle("SEARCH", for: .normal)
    searchButton.setTitleColor(.black, for: .normal)
    
    tableView.backgroundColor = UIColor.groupTableViewBackground
    backgroundColor = UIColor.groupTableViewBackground
    searchButton.backgroundColor = .white
  }
}
