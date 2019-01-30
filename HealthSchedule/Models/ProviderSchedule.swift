//
//  ProviderSchedule.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProviderScheduleJsonFields: String {
  case id = "id"
  case providerId = "provider_id"
  case weekDay = "week_day"
  case startTime = "start_time"
  case endTime = "end_time"
  case workingStatus = "working"
}

struct ProviderSchedule {
  var id: Int
  var providerId: Int
  var weekDay: Int
  var startTime: Date
  var endTime: Date
  var workingStatus: Int
}

extension ProviderSchedule: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[ProviderScheduleJsonFields.id.rawValue] as? Int,
      let providerId = json[ProviderScheduleJsonFields.providerId.rawValue] as? Int,
      let weekDay = json[ProviderScheduleJsonFields.weekDay.rawValue] as? Int,
      let startTime = json[ProviderScheduleJsonFields.startTime.rawValue] as? Date,
      let endTime = json[ProviderScheduleJsonFields.endTime.rawValue] as? Date,
      let workingStatus = json[ProviderScheduleJsonFields.workingStatus.rawValue] as? Int else {
        print("Cannot parse json fields in ProviderSchedule.init!")
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
