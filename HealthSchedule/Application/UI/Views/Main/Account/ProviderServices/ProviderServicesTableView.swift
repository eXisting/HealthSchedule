//
//  ProviderServicesTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServicesTableView: UITableView {
  static let cellIdentifier = "ProviderServiceCell"
  static let sectionIdentifier = "ProviderServiceHeader"
  
  private let customRefreshControl = UIRefreshControl()
  
  var refreshDelegate: RefreshingTableView?
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = true
    
    register(ProviderServiceCell.self, forCellReuseIdentifier: ProviderServicesTableView.cellIdentifier)
    register(ProviderServiceHeader.self, forHeaderFooterViewReuseIdentifier: ProviderServicesTableView.sectionIdentifier)
    
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
        if responseStatus == ResponseStatus.success.rawValue {
          self?.reloadData()
        }
        
        self?.refreshControl?.endRefreshing()
      }
    }
  }
  
  private func customize() {
    refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: [:])
  }
}
