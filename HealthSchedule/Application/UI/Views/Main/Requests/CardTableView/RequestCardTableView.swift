//
//  RequestCardView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardTableView: UITableView {
  static let cellIdentifier = "RequestCardProviderRow"
  static let sectionIdentifier = "RequestCardSection"
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    register(RequestCardImageRow.self, forCellReuseIdentifier: RequestCardTableView.cellIdentifier)
    register(CommonSection.self, forHeaderFooterViewReuseIdentifier: RequestCardTableView.sectionIdentifier)
    
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
  }
}
