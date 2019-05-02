//
//  ProviderViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import FoldingCell
import NVActivityIndicatorView

protocol DismissableController {
  func dismiss()
}

class ResultViewController: UIViewController, NVActivityIndicatorViewable {
  private var model: ResultsModel!
  private let mainView = SearchResultView()
  
  convenience init(data: RemoteAvailableTimeContainer, serviceId: Int) {
    self.init()
    model = ResultsModel(delegate: self, loaderDelegate: self, container: data, serviceId)
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(delegate: model.tableViewContentHandler, dataSource: model.tableViewContentHandler)
    mainView.dismissDelegate = self
  }
}

extension ResultViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}

extension ResultViewController: DismissableController {
  func dismiss() {
    dismiss(animated: true)
  }
}

extension ResultViewController: TableViewSectionsReloading {
  func reloadSections(_ path: IndexSet, with animation: UITableView.RowAnimation) {
    mainView.reloadSections(path, with: animation)
  }
}

extension ResultViewController: LoaderShowable {
  func showLoader() {
    let size = CGSize(width: self.view.frame.width / 1.5, height: self.view.frame.height * 0.25)
    startAnimating(size, type: .ballClipRotate, color: .white, backgroundColor: UIColor.black.withAlphaComponent(0.75))
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: { [weak self] in
      if self!.isAnimating {
        self?.stopAnimating()
      }
    })
  }
  
  func hideLoader() {
    stopAnimating()
  }
}
