//
//  DateOperationsHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/31/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class DatesManager {
  static let shared = DatesManager()
  
  let dateFormatter = DateFormatter()
  
  private var defaultDate: Date!
  
  func stringToDate(_ dateString: String) -> Date {
    guard let date = dateFormatter.date(from: dateString) else {
      return defaultDate
    }
    
    return date
  }
  
  func dateToString(_ date: Date) -> String {
    return dateFormatter.string(from: date)
  }
  
  private init() {
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    defaultDate = dateFormatter.date(from: "2000-01-01 01:01:01")
  }
}
