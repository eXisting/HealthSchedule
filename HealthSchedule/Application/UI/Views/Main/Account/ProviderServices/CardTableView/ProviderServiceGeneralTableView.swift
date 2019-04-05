//
//  ProviderCreateTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServiceGeneralTableView: UITableView {
  static let cellIdentifier = "ProviderCreateRowCell"
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    register(ProviderServiceRow.self, forCellReuseIdentifier: ProviderServiceGeneralTableView.cellIdentifier)
    
    showsVerticalScrollIndicator = false
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
  }
}

