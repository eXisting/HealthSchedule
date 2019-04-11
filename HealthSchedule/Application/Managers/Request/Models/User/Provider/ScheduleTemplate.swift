//
//  ScheduleTemplate.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ScheduleTemplateJsonFields: String, CodingKey {
  case id
  case providerId = "provider_id"
  case weekDay = "week_day"
  case start = "start_time"
  case end = "end_time"
  case working = "working"
  case schedules = "schedules"
}

struct RemoteScheduleTemplateDay: Codable {
  var id: Int
  var providerId: Int
  var weekDay: Int
  var startTime: Date
  var endTime: Date
  var working: Bool
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ScheduleTemplateJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(providerId, forKey: .providerId)
    try container.encode(weekDay, forKey: .weekDay)
    try container.encode(working, forKey: .working)

    let startDateString = DateManager.shared.date2String(with: .time, startTime, .hour24)
    try container.encode(startDateString, forKey: .start)
    
    let endDateString = DateManager.shared.date2String(with: .time, endTime, .hour24)
    try container.encode(endDateString, forKey: .end)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ScheduleTemplateJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    providerId = try container.decode(Int.self, forKey: .providerId)
    weekDay = try container.decode(Int.self, forKey: .weekDay)
    working = try container.decode(Bool.self, forKey: .working)

    let startDateString = try container.decode(String.self, forKey: .start)
    startTime = DateManager.shared.stringToDate(startDateString, format: .fullTime, .hour24)
    
    let endDateString = try container.decode(String.self, forKey: .end)
    endTime = DateManager.shared.stringToDate(endDateString, format: .fullTime, .hour24)
  }
}
