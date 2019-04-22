//
//  HistoryTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestListTableView: UITableView {
  private let customRefreshControl = UIRefreshControl()
  
  private var refreshDelegate: RefreshingTableView?
  
  static let cellIdentifier = "RequestRow"
  static let sectionIdentifier = "RequestListSection"

  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, refreshDelegate: RefreshingTableView) {
    self.delegate = delegate
    self.dataSource = dataSource
  
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(RequestListRow.self, forCellReuseIdentifier: RequestListTableView.cellIdentifier)
    register(CommonSection.self, forHeaderFooterViewReuseIdentifier: RequestListTableView.sectionIdentifier)

    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
    
    // Configure Refresh Control
    refreshControl = customRefreshControl
    refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
    self.refreshDelegate = refreshDelegate
    
    customize()
  }
  
  @objc private func refresh(_ sender: Any) {
    refreshDelegate?.refresh {
      [weak self] _ in
      DispatchQueue.main.async {
        self?.refreshControl?.endRefreshing()
      }
    }
  }
  
  private func customize() {
    refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: [:])
  }
}
