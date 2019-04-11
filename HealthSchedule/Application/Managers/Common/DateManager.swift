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
  case humanDateTime = "MMM d, hh:mm"
  case time = "HH:mm"
  case fullTime = "HH:mm:ss"
}

enum DateTimeLocale {
  case hour24
  case posix
  case none
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
  
  func stringToDate(_ dateString: String, format: DateFormatType, _ locale: DateTimeLocale = .none) -> Date {
    dynamicFormatter.dateFormat = format.rawValue
    dynamicFormatter.locale = getLocale(locale)
    guard let date = dynamicFormatter.date(from: dateString) else {
      return defaultDate
    }
    
    return date
  }
  
  func dateToString(_ date: Date?) -> String {
    guard let date = date else { return "no date" }
    
    return dateFormatter.string(from: date)
  }
  
  func date2String(with format: DateFormatType, _ date: Date, _ locale: DateTimeLocale = .none) -> String {
    dynamicFormatter.dateFormat = format.rawValue
    dynamicFormatter.locale = getLocale(locale)
    return dynamicFormatter.string(from: date)
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
  
  func getAvailableServiceTimeRange() -> (min: Date, max: Date) {
    let minDate = DateManager.shared.stringToDate("06:00", format: .time, .hour24)
    let maxDate = DateManager.shared.stringToDate("23:00", format: .time, .hour24)

    return (minDate, maxDate)
  }
  
  func getExpirationDate(expires: Int) -> Date {
    let currentDate = Date()
    var dateComponents = DateComponents()
    let calendar = Calendar.init(identifier: .gregorian)
    dateComponents.second = expires
    
    return calendar.date(byAdding: dateComponents, to: currentDate)!
  }
  
  func getLocale(_ locale: DateTimeLocale = .none) -> Locale {
    switch locale {
    case .hour24:
      return NSLocale(localeIdentifier: "en_GB") as Locale
    case .posix:
      return NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    case .none:
      return NSLocale.current
    }
  }
  
  func combineDateWithTime(date: Date, time: Date) -> Date? {
    let calendar = NSCalendar.current
    
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
    
    var mergedComponments = DateComponents()
    mergedComponments.year = dateComponents.year!
    mergedComponments.month = dateComponents.month!
    mergedComponments.day = dateComponents.day!
    mergedComponments.hour = timeComponents.hour!
    mergedComponments.minute = timeComponents.minute!
    mergedComponments.second = timeComponents.second!
    
    return calendar.date(from: mergedComponments)
  }
  
  func compareDates(start: String, end: String, format: DateFormatType, locale: DateTimeLocale) -> ComparisonResult {
    let start = DateManager.shared.stringToDate(start, format: format, locale)
    let end = DateManager.shared.stringToDate(end, format: format, locale)
    return Calendar.current.compare(start, to: end, toGranularity: .minute)
  }
  
  func getDateAccordingToThisWeek(weekDayIndex: Int) -> Date {
    return Date().currentWeekMonday.add(component: .day, value: weekDayIndex)
  }
  
  func date2WeekDayIndex(_ date: Date) -> Int {
    // week index - 2 cause working in ISO format and values starts from 1
    let index = Calendar(identifier: .iso8601).dateComponents([.weekday], from: date).weekday! - 2
    
    // if index is negative - it is last day of the week - return its index as 6
    if index < 0 {
      return 6
    }
    
    return index
  }
  
  private init() {
    dateFormatter.dateFormat = DateFormatType.date.rawValue
    defaultDate = dateFormatter.date(from: "1000-01-01")
  }
}
