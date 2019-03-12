//
//  DateOperationsHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/31/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum DateFormatType: String {
  case date = "yyyy-MM-dd"
  case dateTime = "yyyy-MM-dd HH:mm:ss"
}

class DateManager {
  static let shared = DateManager()
  
  private let dateFormatter = DateFormatter()
  private let dynamicFormatter = DateFormatter()
  
  private var defaultDate: Date!
  
  func stringToDate(_ dateString: String) -> Date {
    guard let date = dateFormatter.date(from: dateString) else {
      return defaultDate
    }
    
    return date
  }
  
  func stringToDate(_ dateString: String, format: DateFormatType) -> Date {
    dynamicFormatter.dateFormat = format.rawValue
    guard let date = dynamicFormatter.date(from: dateString) else {
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
  
  func getExpirationDate(expires: Int) -> Date {
    let currentDate = Date()
    var dateComponents = DateComponents()
    let calendar = Calendar.init(identifier: .gregorian)
    dateComponents.second = expires
    
    return calendar.date(byAdding: dateComponents, to: currentDate)!
  }
  
  private init() {
    dateFormatter.dateFormat = DateFormatType.date.rawValue
    defaultDate = dateFormatter.date(from: "1000-01-01")
  }
}
