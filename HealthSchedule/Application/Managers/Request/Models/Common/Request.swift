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
  case providerService = "provider_service"
  case status
  
  case description
  case rate
  case requestAt = "request_at"
}

struct RemoteRequest {
  var id: Int
  var customerId: Int
  var providerId: Int
  
  var rate: Int?
  var description: String
  var requestAt: Date
  
  var status: ReqeustStatus
  var providerService: RemoteProviderService
  
  var customer: RemoteUser?
  var isUserSide: Bool = true
}

extension RemoteRequest: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: RequestJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(customerId, forKey: .userId)
    try container.encode(providerService, forKey: .providerService)
    try container.encode(status.value, forKey: .status)
    try container.encode(rate, forKey: .rate)
    try container.encode(description, forKey: .description)

    let date = DateManager.shared.dateToString(requestAt)
    try container.encode(date, forKey: .requestAt)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: RequestJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    customerId = try container.decode(Int.self, forKey: .userId)
    rate = try? container.decode(Int.self, forKey: .rate)
    description = try container.decode(String.self, forKey: .description)

    let dateString = try container.decode(String.self, forKey: .requestAt)
    requestAt = DateManager.shared.stringToDate(dateString, format: .dateTime)
    
    let statusInt = try container.decode(Int.self, forKey: .status)
    status = ReqeustStatus(statusInt)
    
    providerService = try container.decode(RemoteProviderService.self, forKey: .providerService)
    customer = providerService.customer
    
    if customer != nil {
      isUserSide = false
    }
    
    providerId = providerService.providerId
  }
}

enum RequestStatusName: String {
  case done = "Done"
  case pending = "Pending"
  case rejected = "Rejected"
  case accepted = "Accepted"
  
  case unknown = "Unknown status"
}

struct ReqeustStatus {
  var value: Int
  var title: RequestStatusName
  
  init(_ status: Int?) {
    guard let status = status else {
      value = 4
      title = .unknown
      return
    }
    
    value = status
    
    title = ReqeustStatus.statusValue2RequestStatusName(value: value)
  }
  
  static func statusValue2RequestStatusName(value: Int) -> RequestStatusName {
    switch value {
    case 1:
      return .done
    case 2:
      return .rejected
    case 3:
      return .accepted
    case 4:
      return .pending
    default:
      return .unknown
    }
  }
  
  static func statusName2RValue(value: RequestStatusName) -> Int {
    switch value {
    case .accepted:
      return 3
    case .rejected:
      return 2
    case .pending:
      return 4
    case .done:
      return 1
    default:
      return 5
    }
  }
}
