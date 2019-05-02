//
//  ResultProviderViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ResultProviderViewController: UIViewController {
  private let titleName = "Chosen provider"
  
  private let mainView = ChosenProviderView()
  private var model: ChosenProviderModel!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  convenience init(providerId: Int, serviceId: Int, time: Date) {
    self.init()
    model = ChosenProviderModel(providerId, serviceId, time)
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(delegate: self, dataSource: model.dataSource)
    
    setupNavigationItem()
  }
  
  private func setupNavigationItem() {
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationItem.title = titleName
  }
}

extension ResultProviderViewController: UITableViewDelegate {
  
}
