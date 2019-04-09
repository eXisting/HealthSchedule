//
//  DefaultEvent.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//


import Foundation
import JZCalendarWeekView

class DefaultEvent: JZBaseEvent {
  var location: String
  var title: String
  var status: Bool
  
  init(id: String, title: String, startDate: Date, endDate: Date, location: String, status: Bool) {
    self.location = location
    self.title = title
    self.status = status
    
    super.init(id: id, startDate: startDate, endDate: endDate)
  }
    
  override func copy(with zone: NSZone?) -> Any {
    return DefaultEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location, status: status)
  }
}
