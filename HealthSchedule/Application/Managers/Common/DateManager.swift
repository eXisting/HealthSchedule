//
//  DateOperationsHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/31/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class DateManager {
  static let shared = DateManager()
  
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
  
  func getAvailableBirthdayRange() -> (min: Date, max: Date) {
    let currentDate = Date()
    var dateComponents = DateComponents()
    let calendar = Calendar.init(identifier: .gregorian)
    dateComponents.year = -80
    let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
    dateComponents.year = -13
    let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
    
    return (minDate!, maxDate!)
  }
  
  private init() {
    dateFormatter.dateFormat = "yyyy-MM-dd"
    defaultDate = dateFormatter.date(from: "1000-01-01")
  }
}
