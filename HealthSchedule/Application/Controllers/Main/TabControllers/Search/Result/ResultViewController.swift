//
//  ProviderViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol DismissableController {
  func dismiss()
}

class ResultViewController: UIViewController {
  private let mainView = SearchResultView()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup()
    mainView.dismissDelegate = self
  }
}

extension ResultViewController: DismissableController {
  func dismiss() {
    dismiss(animated: true)
  }
}
