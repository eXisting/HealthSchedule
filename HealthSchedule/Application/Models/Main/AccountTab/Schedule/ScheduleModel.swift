//
//  ScheduleModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class ScheduleModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  
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
  
  var events: [DefaultEvent] = []
  
  lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
}
