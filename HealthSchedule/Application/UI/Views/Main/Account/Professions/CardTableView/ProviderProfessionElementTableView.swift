//
//  ProviderProfessionElementTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr

class ProviderProfessionElementTableView: UITableView {
  lazy var presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .crossDissolve
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    customPresenter.cornerRadius = 50
    return customPresenter
  }()
  
  static let cellIdentifier = "ProviderProfessionCreateRowCell"
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    register(GeneralIdentifyingRow.self, forCellReuseIdentifier: ProviderServiceGeneralTableView.cellIdentifier)
    
    showsVerticalScrollIndicator = false
    alwaysBounceVertical = false
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: .zero)
  }
}
