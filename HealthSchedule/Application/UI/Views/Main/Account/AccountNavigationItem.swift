//
//  AccountNavigationBar.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 3/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit



class AccountNavigationItem: UINavigationItem {
  var delegate: AccountHandleDelegating
  
  init(title: String, delegate: AccountHandleDelegating) {
    self.delegate = delegate
    
    super.init(title: title)
    
    leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutClick))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func onLogoutClick() {
    delegate.logout()
  }
}
