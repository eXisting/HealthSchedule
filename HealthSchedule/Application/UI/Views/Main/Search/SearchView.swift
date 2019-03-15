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
  private let noDataView = NoDataView()
  
  private let headerView = NavigationHoverHeaderView()
  private let searchButton = UIButton()
  
  var searchDelegate: SearchResponsible?

  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    
    headerView.setup()
    noDataView.setup("There is nothng to display...")
    tableView.setup(delegate: delegate, dataSource: dataSource)
    
    searchButton.addTarget(self, action: #selector(onSearchButtonClick), for: .touchDown)
  }
  
  func toggleViews(isDataPresent: Bool) {
    noDataView.isHidden = isDataPresent
    tableView.isHidden = !isDataPresent
  }
  
  @objc private func onSearchButtonClick() {
    searchDelegate?.startSearch()
  }
  
  private func laidOutViews() {
    addSubview(tableView)
    addSubview(noDataView)
    addSubview(headerView)
    addSubview(searchButton)

    headerView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    noDataView.translatesAutoresizingMaskIntoConstraints = false
    searchButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: searchButton, attribute: .top, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: searchButton, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.65, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: searchButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.05, constant: 0).isActive = true

    NSLayoutConstraint(item: noDataView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: noDataView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: noDataView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: noDataView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    tableView.isHidden = true
    
    searchButton.roundBorder()
    searchButton.setTitle("SEARCH", for: .normal)
    searchButton.backgroundColor = .clear
    searchButton.setTitleColor(.black, for: .normal)
  }
}
