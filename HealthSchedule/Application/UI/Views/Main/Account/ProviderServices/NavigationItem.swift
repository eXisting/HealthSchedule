//
//  NavigationItem.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ProviderServiceHandling {
  func back()
  func main()
}

enum ProviderServicesNavigationItemType {
  case save
  case create
}

class ProviderServicesNavigationItem: UINavigationItem {
  var delegate: ProviderServiceHandling
  
  init(title: String, delegate: ProviderServiceHandling, type: ProviderServicesNavigationItemType) {
    self.delegate = delegate
    
    super.init(title: title)
    
    rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: (type == .create ? .add : .save), target: self, action: #selector(onDynamicItemClick))
    leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onSaveClick))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func onSaveClick() {
    delegate.back()
  }
  
  @objc private func onDynamicItemClick() {
    delegate.main()
  }
}

