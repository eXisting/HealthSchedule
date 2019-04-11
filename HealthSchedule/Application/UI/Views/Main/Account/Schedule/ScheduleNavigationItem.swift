//
//  ScheduleNavigationItem.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ScheduleNavigationItem: UINavigationItem {
  var delegate: ScheduleNavigationItemDelegate
  
  init(title: String, delegate: ScheduleNavigationItemDelegate) {
    self.delegate = delegate
    
    super.init(title: title)
    
    rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSaveClick))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func onSaveClick() {
    delegate.save()
  }
}
