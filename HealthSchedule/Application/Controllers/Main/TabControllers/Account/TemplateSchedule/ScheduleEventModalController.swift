//
//  ScheduleEventView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol TableViewMasteringDelegate {
  func dequeueReusableHeader(identifier: String) -> UITableViewHeaderFooterView?
  func dequeueReusableCell(identifier: String, for indexPath: IndexPath) -> UITableViewCell
  func reloadSections(_ path: IndexSet, with animation: UITableView.RowAnimation)
}

class ScheduleEventModalController: UIViewController {
  private let mainView = ScheduleEventTableView()
  private var model: ScheduleModalDayModel!
  
  convenience init(startDate: Date, delegate: ScheduleNavigationItemDelegate) {
    self.init()
    model = ScheduleModalDayModel(startDate: startDate, saveDelegate: delegate, tableViewMasterDelegate: self)
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.setup(delegate: model.dataSource, dataSource: model.dataSource)
  }
}

extension ScheduleEventModalController: TableViewMasteringDelegate {
  func dequeueReusableHeader(identifier: String) -> UITableViewHeaderFooterView? {
    return mainView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
  }
  
  func dequeueReusableCell(identifier: String, for indexPath: IndexPath) -> UITableViewCell {
    return mainView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
  }
  
  func reloadSections(_ path: IndexSet, with animation: UITableView.RowAnimation) {
    mainView.reloadSections(path, with: animation)
  }
}
