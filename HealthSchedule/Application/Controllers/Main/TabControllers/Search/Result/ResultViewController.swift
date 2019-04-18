//
//  ProviderViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FoldingCell

protocol DismissableController {
  func dismiss()
}

class ResultViewController: UIViewController {
  private var model: ResultsModel!
  private let mainView = SearchResultView()
  
  convenience init(data: RemoteAvailableTimeContainer, serviceId: Int) {
    self.init()
    model = ResultsModel(container: data, serviceId)
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
    AlertHandler.ShowAlert(for: self, "Notice", message, .alert)
  }
}

extension ResultViewController: DismissableController {
  func dismiss() {
    dismiss(animated: true)
  }
}
