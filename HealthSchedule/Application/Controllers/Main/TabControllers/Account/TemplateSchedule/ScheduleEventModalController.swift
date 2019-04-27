//
//  ScheduleEventView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView

protocol TableViewSectionsReloading {
  func reloadSections(_ path: IndexSet, with animation: UITableView.RowAnimation)
}

protocol TableViewMasteringDelegate: TableViewSectionsReloading {
  func dequeueReusableHeader(identifier: String) -> UITableViewHeaderFooterView?
  func dequeueReusableCell(identifier: String, for indexPath: IndexPath) -> UITableViewCell
  func redrawSection(_ path: IndexPath)
}

class ScheduleEventModalController: UIViewController {
  private let mainView = ScheduleEventModalView()
  private var model: ScheduleModalDayModel!
  
  var eventsDelegate: ScheduleEventHandling!
  
  convenience init(startDate: Date, endDate: Date? = nil, status: WorkingStatus = .working) {
    self.init()
    model = ScheduleModalDayModel(startDate: startDate, tableViewMasterDelegate: self, endDate, status)
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(acceptHandler: onSaveClickHandle, declineHandler: onCancelClickHandle)
    mainView.tableView.setup(delegate: model.dataSource, dataSource: model.dataSource)
    
    hideKeyboardWhenTappedAround()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    mainView.addBordersTosButtons()
  }
  
  private func onSaveClickHandle() {
    model.save(errorCall: showWarningAlert, onSuccess: { event in
      eventsDelegate.updateAddEvent(event: event)
      dismiss(animated: true, completion: nil) }
    )
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
  
  func redrawSection(_ path: IndexPath) {
    guard let header = mainView.tableView.headerView(forSection: path.section) as? ScheduleModalTableViewHader else {
      fatalError()
    }
    
    header.data.displayData = model.dataSource[path.section].displayData
    header.setNeedsLayout()
  }
}


extension ScheduleEventModalController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}
