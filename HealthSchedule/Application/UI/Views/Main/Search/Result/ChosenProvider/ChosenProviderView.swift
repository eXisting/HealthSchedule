//
//  ChosenProviderView.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import Presentr
import EasyPeasy

class ChosenProviderView: UIView {
  private let tableView = AccountTableView()
  
  private let headerView = NavigationHoverHeaderView()
  
  lazy var presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .crossDissolve
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    customPresenter.cornerRadius = 10
    return customPresenter
  }()
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    headerView.setup()
    tableView.setup(delegate: delegate, dataSource: dataSource)
  }
  
  func setRefreshDelegate(delegate: RefreshingTableView) {
    tableView.refreshDelegate = delegate
  }
  
  func reloadRows(at indexPath: [IndexPath]) {
    tableView.reloadRows(at: indexPath, with: .fade)
  }
  
  private func laidOutViews() {
    addSubview(headerView)
    addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    headerView.easy.layout([
      Height(*0.1).like(self),
      Width().like(self),
      CenterX().to(self),
      Top().to(self)
    ])
    
    tableView.easy.layout([
      Top(==16).to(headerView, .bottom),
      Width().like(self),
      CenterX().to(self)
    ])
  }
  
  private func customizeViews() {
    backgroundColor = .white
  }
}
