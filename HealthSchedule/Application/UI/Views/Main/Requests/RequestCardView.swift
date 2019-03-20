//
//  RequestCardView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardView: UITableView {
  static let cellIdentifier = "RequestCardRow"
  static let sectionIdentifier = "RequestCardSection"
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(RequestListRow.self, forCellReuseIdentifier: RequestCardView.cellIdentifier)
    register(CommonSection.self, forHeaderFooterViewReuseIdentifier: RequestCardView.sectionIdentifier)
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
  }
}
