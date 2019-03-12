//
//  HomeTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class HomeTableView: UITableView {
  static let cellIdentifier = "HomeRow"
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(HistoryRow.self, forCellReuseIdentifier: HomeTableView.cellIdentifier)
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
  }
}

