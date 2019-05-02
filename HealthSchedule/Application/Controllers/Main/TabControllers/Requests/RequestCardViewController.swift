//
//  RequestCardViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

class RequestCardViewController: UIViewController, NVActivityIndicatorViewable {
  private let mainView = RequestCardContainerView()
  private var model: RequestCardModel!
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  convenience init(_ request: Request) {
    self.init()
    
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
  
  @objc private func onAccept() {
    showLoader()
    
    model.updateRequest(status: .accepted) { [weak self] in
      DispatchQueue.main.async {
        self?.stopAnimating()
        self?.dismiss(animated: true)
      }
    }
  }
  
  @objc private func onDecline() {
    showLoader()
    
    model.updateRequest(status: .rejected) { [weak self] in
      DispatchQueue.main.async {
        self?.stopAnimating()
        self?.dismiss(animated: true)
      }
    }
  }
  
  private func showLoader() {
    startAnimating(
      CGSize(width: view.frame.width / 2, height: view.frame.height * 0.25),
      message: "Refreshing...",
      type: .ballPulse,
      color: .white,
      padding: 16
    )
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
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
    if isAnimating {
      stopAnimating()
    }
    
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}
