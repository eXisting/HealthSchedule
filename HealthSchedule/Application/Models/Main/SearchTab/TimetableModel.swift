//
//  TimetableModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FSCalendar

class TimetableModel {
  let dataSourceHandler: FSCalendarDataSource = CalendarDataSourceHandler()
}

class CalendarDataSourceHandler: NSObject, FSCalendarDataSource {
  
  
  func minimumDate(for calendar: FSCalendar) -> Date {
    return Date()
  }
}
