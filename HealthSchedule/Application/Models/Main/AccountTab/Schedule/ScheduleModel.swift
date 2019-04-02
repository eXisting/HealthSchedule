//
//  ScheduleModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FSCalendar

class ScheduleModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  let timetableDataSource = ScheduleTemplateDataSource()
  
  func loadProviderScheduleTemplate(_ completion: @escaping () -> Void) {
    requestManager.getScheduleTemplate { response in
      if response == ResponseStatus.success.rawValue {
        
      }
    }
  }
  
  func onDatePicked(date: Date) {
    
  }
  
  func onDateDeselected(date: Date) {
    
  }
}

class ScheduleTemplateDataSource: NSObject, FSCalendarDataSource {
  fileprivate var data: [ScheduleDayTemplate] = []
  
  func minimumDate(for calendar: FSCalendar) -> Date {
    return Date.today().next(.monday)
  }
  
  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    guard let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as? ScheduleTemplateDayCell else {
      fatalError("Register cell for Calendar!")
    }
        
    return cell
  }
}
