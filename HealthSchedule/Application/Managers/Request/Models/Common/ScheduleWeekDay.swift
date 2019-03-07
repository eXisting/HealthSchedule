//
//  ScheduleWeekDay.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct RemoteScheduleWeekDay {
  var id: Int
  var providerId: Int
  var weekDay: Int
  var workingStatus: Int
  
  var startTime: Date
  var endTime: Date
}

extension RemoteScheduleWeekDay: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ScheduleJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(providerId, forKey: .providerId)
    try container.encode(weekDay, forKey: .weekDay)
    try container.encode(workingStatus, forKey: .workingStatus)

    let startnDateString = DateManager.shared.dateToString(startTime)
    try container.encode(startnDateString, forKey: .startTime)
    
    let endDateString = DateManager.shared.dateToString(endTime)
    try container.encode(endDateString, forKey: .endTime)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ScheduleJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    providerId = try container.decode(Int.self, forKey: .providerId)
    weekDay = try container.decode(Int.self, forKey: .weekDay)
    workingStatus = try container.decode(Int.self, forKey: .workingStatus)
    
    let startString = try container.decode(String.self, forKey: .startTime)
    let endString = try container.decode(String.self, forKey: .endTime)
    
    startTime = DateManager.shared.stringToDate(startString)
    endTime = DateManager.shared.stringToDate(endString)
  }
}
