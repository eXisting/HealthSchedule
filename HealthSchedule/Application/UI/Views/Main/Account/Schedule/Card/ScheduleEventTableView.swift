//
//  ScheduleEventTableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ScheduleEventTableView: UITableView {
  static let selectableCellIdentifier = "ScheduleTimeSelectableRow"
  static let timePickingCellIdentifier = "ScheduleTimeTimePickingeRow"
  static let sectionIdentifier = "ScheduleEventTableViewSection"
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    self.delegate = delegate
    self.dataSource = dataSource
    
    alwaysBounceVertical = false
    showsVerticalScrollIndicator = false
    
    register(ScheduleModalTableViewSelectableRow.self, forCellReuseIdentifier: ScheduleEventTableView.selectableCellIdentifier)
    register(ScheduleModalTableViewDatePickerRow.self, forCellReuseIdentifier: ScheduleEventTableView.timePickingCellIdentifier)
    register(ScheduleModalTableViewHader.self, forHeaderFooterViewReuseIdentifier: ScheduleEventTableView.sectionIdentifier)
    
    // Remove last underline in table view
    tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
  }
}
