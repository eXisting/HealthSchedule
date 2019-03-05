//
//  ScheduleDateException.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ScheduleJsonFields: String, CodingKey {
  case id
  case providerId = "provider_id"
  case workingStatus = "working"
  
  case weekDay = "week_day"
  
  case exceptionAt = "exception_at"
  case startTime = "start_time"
  case endTime = "end_time"
}

struct ScheduleDateException {
  var id: Int
  var providerId: Int
  var workingStatus: Int
 
  var exceptionAt: Date
  var startTime: Date
  var endTime: Date
}

extension ScheduleDateException: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ScheduleJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(providerId, forKey: .providerId)
    try container.encode(workingStatus, forKey: .workingStatus)
    
    let exceptionDateString = DateManager.shared.dateToString(exceptionAt)
    try container.encode(exceptionDateString, forKey: .exceptionAt)
    
    let startDateString = DateManager.shared.dateToString(exceptionAt)
    try container.encode(startDateString, forKey: .startTime)
    
    let endDateString = DateManager.shared.dateToString(exceptionAt)
    try container.encode(endDateString, forKey: .endTime)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ScheduleJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    providerId = try container.decode(Int.self, forKey: .providerId)
    workingStatus = try container.decode(Int.self, forKey: .workingStatus)
    
    let dateString = try container.decode(String.self, forKey: .exceptionAt)
    let startString = try container.decode(String.self, forKey: .startTime)
    let endString = try container.decode(String.self, forKey: .endTime)
    
    exceptionAt = DateManager.shared.stringToDate(dateString)
    startTime = DateManager.shared.stringToDate(startString)
    endTime = DateManager.shared.stringToDate(endString)
  }
}
