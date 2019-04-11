//
//  DateExtension.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import Foundation

extension Date {
  
  static func today() -> Date {
    return Date()
  }
  
  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.Next,
               weekday,
               considerToday: considerToday)
  }
  
  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.Previous,
               weekday,
               considerToday: considerToday)
  }
  
  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {
    
    let dayName = weekDay.rawValue
    
    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
    
    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
    
    let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
    
    let calendar = Calendar(identifier: .gregorian)
    
    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }
    
    var nextDateComponent = DateComponents()
    nextDateComponent.weekday = searchWeekdayIndex
    
    
    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)
    
    return date!
  }
  
}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }
  
  var currentWeekMonday: Date {
    return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
  }

  static func dayIndex2WeekDay(_ index: Int) -> Weekday {
    switch index {
    case 0:
      return .monday
    case 1:
      return .tuesday
    case 2:
      return .wednesday
    case 3:
      return .thursday
    case 4:
      return .friday
    case 5:
      return .saturday
    case 6:
      return .sunday
      
    default:
      return .monday
    }
  }
  
  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }
  
  enum SearchDirection {
    case Next
    case Previous
    
    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .Next:
        return .forward
      case .Previous:
        return .backward
      }
    }
  }
}
