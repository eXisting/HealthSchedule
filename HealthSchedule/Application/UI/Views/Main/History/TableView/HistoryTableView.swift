//
//  HistoryTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HistoryTableView: UITableView {
  static let cellIdentifier = "HistoryRow"
  static let sectionIdentifier = "HistorySection"

  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
  
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(HistoryRow.self, forCellReuseIdentifier: HistoryTableView.cellIdentifier)
    register(CommonSection.self, forHeaderFooterViewReuseIdentifier: HistoryTableView.sectionIdentifier)

    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
  }
}
