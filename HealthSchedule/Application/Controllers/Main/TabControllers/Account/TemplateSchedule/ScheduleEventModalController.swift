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
  private let mainView = ScheduleEventModalView()
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
    mainView.setup(acceptHandler: onSaveClickHandle, declineHandler: onCancelClickHandle)
    mainView.tableView.setup(delegate: model.dataSource, dataSource: model.dataSource)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    mainView.addBordersTosButtons()
  }
  
  private func onSaveClickHandle() {
    model.save(errorCall: showWarningAlert, onSuccess: { dismiss(animated: true, completion: nil) })
  }
  
  private func onCancelClickHandle() {
    dismiss(animated: true, completion: nil)
  }
}

extension ScheduleEventModalController: TableViewMasteringDelegate {
  func dequeueReusableHeader(identifier: String) -> UITableViewHeaderFooterView? {
    return mainView.tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
  }
  
  func dequeueReusableCell(identifier: String, for indexPath: IndexPath) -> UITableViewCell {
    return mainView.tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
  }
  
  func reloadSections(_ path: IndexSet, with animation: UITableView.RowAnimation) {
    mainView.tableView.reloadSections(path, with: animation)
  }
}


extension ScheduleEventModalController: ErrorShowable {
  func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(for: self, "Error", message, .alert)
  }
}
