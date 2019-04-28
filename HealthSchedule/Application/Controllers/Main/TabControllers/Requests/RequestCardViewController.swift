//
//  RequestCardViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView

class RequestCardViewController: UIViewController {
  private let mainView = RequestCardContainerView()
  private var model: RequestCardModel!
  
  private var parentAction: (() -> Void)!
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  convenience init(_ request: Request, _ parentAction: @escaping () -> Void) {
    self.init()
    self.parentAction = parentAction
    
    model = RequestCardModel(request: request, errorDelegate: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(actionsCount: model.getActionsCount(), role: model.getCurrentUserRole())
    mainView.tableView.setup(delegate: self, dataSource: model.dataSource)
    mainView.setup(acceptHandler: onAccept, declineHandler: onDecline)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    mainView.laidOutViews()
  }
  
  @objc func onAccept() {
    model.updateRequest(status: .accepted)
    parentAction()
  }
  
  @objc func onDecline() {
    model.updateRequest(status: .rejected)
    parentAction()
  }
}

extension RequestCardViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return model[section].sectionHeight
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return model[indexPath.section][indexPath.row].rowHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    guard let cell = tableView.cellForRow(at: indexPath) else {
//      return
//    }
    
    // TODO: present provider view on first row click
  }
}

extension RequestCardViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}
