//
//  TimetableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FSCalendar

class TimetableView: UIView {
  private let calendar = FSCalendar()
  
  func setup(delegate: FSCalendarDelegate, dataSource: FSCalendarDataSource) {
    laidOutViews()
    
    calendar.dataSource = dataSource
    calendar.delegate = delegate
  }
  
  private func laidOutViews() {
    addSubview(calendar)
    
    calendar.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: calendar, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
  }
}
