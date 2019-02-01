//
//  ScheduleWeekDay.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ScheduleWeekDayJsonFields: String {
  case id = "id"
  case providerId = "provider_id"
  case weekDay = "week_day"
  case startTime = "start_time"
  case endTime = "end_time"
  case workingStatus = "working"
}

struct ScheduleWeekDay {
  var id: Int
  var providerId: Int
  var weekDay: Int
  var startTime: Date
  var endTime: Date
  var workingStatus: Int
}

extension ScheduleWeekDay: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[ScheduleWeekDayJsonFields.id.rawValue] as? Int,
      let providerId = json[ScheduleWeekDayJsonFields.providerId.rawValue] as? Int,
      let weekDay = json[ScheduleWeekDayJsonFields.weekDay.rawValue] as? Int,
      let startTime = json[ScheduleWeekDayJsonFields.startTime.rawValue] as? Date,
      let endTime = json[ScheduleWeekDayJsonFields.endTime.rawValue] as? Date,
      let workingStatus = json[ScheduleWeekDayJsonFields.workingStatus.rawValue] as? Int else {
        print("Cannot parse json fields in ScheduleWeekDay.init!")
        return nil
    }
    
    self.id = id
    self.providerId = providerId
    self.weekDay = weekDay
    self.startTime = startTime
    self.endTime = endTime
    self.workingStatus = workingStatus
  }
}

extension ScheduleWeekDay: JsonConvertable {
  func asJson() -> Serializer.JsonDictionary {
    let formatter = DatesManager.shared.dateFormatter
    
    return [
      ScheduleWeekDayJsonFields.id.rawValue: String(id),
      ScheduleWeekDayJsonFields.providerId.rawValue: String(providerId),
      ScheduleWeekDayJsonFields.weekDay.rawValue: String(weekDay),
      ScheduleWeekDayJsonFields.startTime.rawValue: formatter.string(from: startTime),
      ScheduleWeekDayJsonFields.endTime.rawValue: formatter.string(from: endTime),
      ScheduleWeekDayJsonFields.workingStatus.rawValue: String(workingStatus)
    ]
  }
}
