//
//  Request.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/7/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum RequestJsonFields: String, CodingKey {
  case id
  case userId = "user_id"
  case providerServiceId = "provider_service_id"
  case statusId = "status_id"
  
  case description
  case rate
  case requestAt = "request_at"
}

struct RemoteRequest {
  var id: Int
  var userId: Int
  var providerServiceId: Int
  var statusId: Int
  
  var rate: Int
  var description: String
  var requestAt: Date
}

extension RemoteRequest: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: RequestJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(userId, forKey: .userId)
    try container.encode(providerServiceId, forKey: .providerServiceId)
    try container.encode(statusId, forKey: .statusId)
    try container.encode(rate, forKey: .rate)
    try container.encode(description, forKey: .description)

    let date = DateManager.shared.dateToString(requestAt)
    try container.encode(date, forKey: .requestAt)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: RequestJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    userId = try container.decode(Int.self, forKey: .userId)
    providerServiceId = try container.decode(Int.self, forKey: .providerServiceId)
    statusId = try container.decode(Int.self, forKey: .statusId)
    rate = try container.decode(Int.self, forKey: .rate)
    description = try container.decode(String.self, forKey: .description)

    let dateString = try container.decode(String.self, forKey: .requestAt)
    requestAt = DateManager.shared.stringToDate(dateString, format: .dateTime)
  }
}
