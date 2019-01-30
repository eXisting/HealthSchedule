//
//  ProviderScheduleException.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProviderScheduleExceptionJsonFields: String {
  case id = "id"
  case providerId = "provider_id"
  case exceptionAt = "exception_at"
  case startTime = "start_time"
  case endTime = "end_time"
  case workingStatus = "working"
}

struct ProviderScheduleException {
  var id: Int
  var providerId: Int
  var exceptionAt: Date
  var startTime: Date
  var endTime: Date
  var workingStatus: Int
}

extension ProviderScheduleException: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[ProviderScheduleExceptionJsonFields.id.rawValue] as? Int,
      let providerId = json[ProviderScheduleExceptionJsonFields.providerId.rawValue] as? Int,
      let exceptionAt = json[ProviderScheduleExceptionJsonFields.exceptionAt.rawValue] as? Date,
      let startTime = json[ProviderScheduleExceptionJsonFields.startTime.rawValue] as? Date,
      let endTime = json[ProviderScheduleExceptionJsonFields.endTime.rawValue] as? Date,
      let workingStatus = json[ProviderScheduleExceptionJsonFields.workingStatus.rawValue] as? Int else {
        print("Cannot parse json fields in ProviderSchedule.init!")
        return nil
    }
    
    self.id = id
    self.providerId = providerId
    self.exceptionAt = exceptionAt
    self.startTime = startTime
    self.endTime = endTime
    self.workingStatus = workingStatus
  }
}

