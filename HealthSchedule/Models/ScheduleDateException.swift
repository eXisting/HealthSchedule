//
//  ScheduleDateException.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ScheduleDateExceptionJsonFields: String {
  case id = "id"
  case providerId = "provider_id"
  case exceptionAt = "exception_at"
  case startTime = "start_time"
  case endTime = "end_time"
  case workingStatus = "working"
}

struct ScheduleDateException {
  var id: Int
  var providerId: Int
  var exceptionAt: Date
  var startTime: Date
  var endTime: Date
  var workingStatus: Int
}

extension ScheduleDateException: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[ScheduleDateExceptionJsonFields.id.rawValue] as? Int,
      let providerId = json[ScheduleDateExceptionJsonFields.providerId.rawValue] as? Int,
      let exceptionAt = json[ScheduleDateExceptionJsonFields.exceptionAt.rawValue] as? Date,
      let startTime = json[ScheduleDateExceptionJsonFields.startTime.rawValue] as? Date,
      let endTime = json[ScheduleDateExceptionJsonFields.endTime.rawValue] as? Date,
      let workingStatus = json[ScheduleDateExceptionJsonFields.workingStatus.rawValue] as? Int else {
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

extension ScheduleDateException: JsonConvertable {
  func asJson() -> RequestHandler.JsonDictionary {
    let formatter = DateOperationsHandler.shared.dateFormatter
    
    return [
      ScheduleDateExceptionJsonFields.id.rawValue: String(id),
      ScheduleDateExceptionJsonFields.providerId.rawValue: String(providerId),
      ScheduleDateExceptionJsonFields.exceptionAt.rawValue: formatter.string(from: exceptionAt),
      ScheduleDateExceptionJsonFields.startTime.rawValue: formatter.string(from: startTime),
      ScheduleDateExceptionJsonFields.endTime.rawValue: formatter.string(from: endTime),
      ScheduleDateExceptionJsonFields.workingStatus.rawValue: String(workingStatus)
    ]
  }
}
