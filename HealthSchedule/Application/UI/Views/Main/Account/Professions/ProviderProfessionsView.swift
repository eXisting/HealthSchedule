//
//  ProfessionsView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy

class ProviderProfessionsView: UITableView {
  static let cellIdentifier = "ProviderProfessionCell"
  
  private let customRefreshControl = UIRefreshControl()
  
  var refreshDelegate: RefreshingTableView?
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(ProviderProfessionViewCell.self, forCellReuseIdentifier: ProviderProfessionsView.cellIdentifier)
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
    
    // Configure Refresh Control
    refreshControl = customRefreshControl
    refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    customize()
  }
  
  @objc private func refresh(_ sender: Any) {
    refreshDelegate?.refresh {
      [weak self] responseStatus in
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
