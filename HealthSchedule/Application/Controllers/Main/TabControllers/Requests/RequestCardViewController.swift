//
//  RequestCardViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardViewController: UIViewController {
  private let mainView = RequestCardContainerView()
  private var model: RequestCardModel!
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  convenience init(_ request: Request) {
    self.init()
    model = RequestCardModel(request: request)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(hasActions: model.isRequestHasActions(), role: model.getCurrentUserRole())
    mainView.tableView.setup(delegate: self, dataSource: model.dataSource)
    mainView.setup(acceptHandler: onAccept, declineHandler: onDecline)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    mainView.laidOutViews()
  }
  
  @objc func onAccept() {
    model.updateRequest(status: .accepted)
  }
  
  @objc func onDecline() {
    model.updateRequest(status: .rejected)
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
