//
//  AccountTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountTableView: UITableView {
  static let placemarkCellIdentifier = "AccountCommonRow"
  static let disclosureCellIdentifier = "AccountDisclosureRow"
  static let sectionIdentifier = "AccountSection"

  private let customRefreshControl = UIRefreshControl()
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(AccountDisclosureCell.self, forCellReuseIdentifier: AccountTableView.disclosureCellIdentifier)
    register(AccountPlacemarkCell.self, forCellReuseIdentifier: AccountTableView.placemarkCellIdentifier)
    register(CommonSection.self, forHeaderFooterViewReuseIdentifier: AccountTableView.sectionIdentifier)
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
    
    // Configure Refresh Control
    refreshControl = customRefreshControl
    refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    customize()
  }
  
  @objc private func refresh(_ sender: Any) {
    
  }
  
  private func customize() {
    refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: [:])
  }
}
