//
//  ProviderService.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProviderServiceJsonFields: String, CodingKey {
  case id
  case price
  case description
  case interval
  
  case providerId = "provider_id"
  case service
  case address
  
  case user
  case provider = "provider"
  
  case serviceId = "service_id"
}

struct RemoteProviderService {
  var id: Int
  var providerId: Int
  var price: Double
  var description: String
  
  var interval: Date
  
  var address: RemoteAddress
  var service: RemoteService
  var provider: RemoteUser?
}

extension RemoteProviderService: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ProviderServiceJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(providerId, forKey: .providerId)
    try container.encode(service, forKey: .service)
    try container.encode(address, forKey: .address)
    try container.encode(price, forKey: .price)
    try container.encode(description, forKey: .description)
    
    if provider != nil {
      try container.encode(provider, forKey: .provider)
    }
    
    let intervalDateString = DateManager.shared.date2String(with: .time, interval, .hour24)
    try container.encode(intervalDateString, forKey: .interval)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ProviderServiceJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    providerId = try container.decode(Int.self, forKey: .providerId)
    service = try container.decode(RemoteService.self, forKey: .service)
    address = try container.decode(RemoteAddress.self, forKey: .address)
    price = try container.decode(Double.self, forKey: .price)
    description = try container.decode(String.self, forKey: .description)
    provider = try? container.decode(RemoteUser.self, forKey: .provider)

    if provider == nil {
      provider = try? container.decode(RemoteUser.self, forKey: .user)
    }
    
    let dateString = try container.decode(String.self, forKey: .interval)
    
    interval = DateManager.shared.stringToDate(dateString, format: .fullTime, .none)
  }
}
