//
//  ProfessionsViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProfessionsViewController: UIViewController {
  private let titleName = "Your experience"
  
  private let model = ProviderProfessionsModel()
  private let mainView = ProviderProfessionsView()
  
  private var customNavigationItem: GeneralActionSaveNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = GeneralActionSaveNavigationItem(title: titleName, delegate: self, type: .create)
      }
      
      return customNavigationItem!
    }
  }
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(delegate: self, dataSource: model.dataSource)
    
    setupNavigationBarAppearance()
  }
  
  private func setupNavigationBarAppearance() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.backgroundColor = .gray
  }
}

extension ProfessionsViewController: UITableViewDelegate {
  
}

extension ProfessionsViewController: GeneralItemHandlingDelegate {
  func back() {
    navigationController?.popViewController(animated: true)
  }
  
  func main() {
    navigationController?.pushViewController(ProviderProfessionCardViewController(profession: nil), animated: true)
  }
}
