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
  private let model = ResultsModel()
  private let mainView = SearchResultView()
  
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

extension ResultViewController: DismissableController {
  func dismiss() {
    dismiss(animated: true)
  }
}
