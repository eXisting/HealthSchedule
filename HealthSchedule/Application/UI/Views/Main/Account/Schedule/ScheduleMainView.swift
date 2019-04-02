//
//  ScheduleMainView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FSCalendar

class ScheduleMainView: UIView {
  private let timetableView = TimetableView()
    
  func setup(timeViewDataSource: FSCalendarDataSource, timeViewDelegate: FSCalendarDelegate) {
    timetableView.setup(dataSource: timeViewDataSource)
    timetableView.calendar.delegate = timeViewDelegate
    
    timetableView.calendar.register(ScheduleTemplateDayCell.self, forCellReuseIdentifier: "cell")
    
    laidOutViews()
  }
  
  private func laidOutViews() {
    addSubview(timetableView)
    
    timetableView.translatesAutoresizingMaskIntoConstraints = false
    timetableView.pin(to: self)
    
    timetableView.calendar.scope = .week
    timetableView.calendar.firstWeekday = 2
    timetableView.calendar.allowsMultipleSelection = true
    timetableView.calendar.headerHeight = 0
    timetableView.calendar.scrollEnabled = false
  }
}
