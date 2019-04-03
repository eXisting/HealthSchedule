//
//  ProviderServicesController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServicesController: UIViewController {
  private let titleName = "Your services"
  private var customNavigationItem: ProviderServicesNavigationItem?
  
  private let model = ProviderServicesModel()
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = ProviderServicesNavigationItem(title: titleName, delegate: self)
      }
      
      return customNavigationItem!
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    model.loadServices {
      
    }
  }
}

extension ProviderServicesController: ProviderServiceHandling {
  func save() {
    print("save")
  }
  
  func create() {
    print("create")
  }
}
