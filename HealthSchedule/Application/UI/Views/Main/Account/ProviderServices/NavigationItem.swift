//
//  NavigationItem.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ProviderServiceHandling {
  func save()
  func create()
}

class ProviderServicesNavigationItem: UINavigationItem {
  var delegate: ProviderServiceHandling
  
  init(title: String, delegate: ProviderServiceHandling) {
    self.delegate = delegate
    
    super.init(title: title)
    
    rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onCreateClick))
    leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onSaveClick))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func onSaveClick() {
    delegate.save()
  }
  
  @objc private func onCreateClick() {
    delegate.create()
  }
}

