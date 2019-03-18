//
//  HistoryTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestListTableView: UITableView {
  static let cellIdentifier = "RequestRow"
  static let sectionIdentifier = "RequestListSection"

  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
  
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(RequestListRow.self, forCellReuseIdentifier: RequestListTableView.cellIdentifier)
    register(CommonSection.self, forHeaderFooterViewReuseIdentifier: RequestListTableView.sectionIdentifier)

    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
  }
}
