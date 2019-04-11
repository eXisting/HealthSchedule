//
//  NavigationItem.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol GeneralItemHandlingDelegate {
  func back()
  func main()
}

enum GeneralNavigationItemType {
  case save
  case create
}

class GeneralActionSaveNavigationItem: UINavigationItem {
  var delegate: GeneralItemHandlingDelegate
  
  init(title: String, delegate: GeneralItemHandlingDelegate, type: GeneralNavigationItemType) {
    self.delegate = delegate
    
    super.init(title: title)
    
    rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: (type == .create ? .add : .save), target: self, action: #selector(onDynamicItemClick))
    leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneClick))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func onDoneClick() {
    delegate.back()
  }
  
  @objc private func onDynamicItemClick() {
    delegate.main()
  }
}

