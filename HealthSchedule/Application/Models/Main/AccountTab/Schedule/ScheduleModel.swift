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
      
    }
  }
  
  func onDatePicked(date: Date) {
    
  }
  
  func onDateDeselected(date: Date) {
    
  }
}

class ScheduleTemplateDataSource: NSObject, FSCalendarDataSource {  
  func minimumDate(for calendar: FSCalendar) -> Date {
    return Date.today().next(.monday)
  }
}
