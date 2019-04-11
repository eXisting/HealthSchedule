//
//  AccountNavigationBar.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 3/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountNavigationItem: UINavigationItem {
  var delegate: AccountHandlableDelegate
  
  init(title: String, delegate: AccountHandlableDelegate) {
    self.delegate = delegate
    
    super.init(title: title)
    
    leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutClick))
    rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSaveClick))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func onLogoutClick() {
    delegate.logout()
  }
  
  @objc private func onSaveClick() {
    delegate.save()
  }
}
