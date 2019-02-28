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
  case serviceId = "service_id"
  case addressId = "address_id"
}

struct ProviderService {
  var id: Int
  var providerId: Int
  var serviceId: Int
  var addressId: Int
  var price: Double
  var description: String
  
  var interval: Date
}

extension ProviderService: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ProviderServiceJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(providerId, forKey: .providerId)
    try container.encode(serviceId, forKey: .serviceId)
    try container.encode(addressId, forKey: .addressId)
    try container.encode(price, forKey: .price)
    try container.encode(description, forKey: .description)

    let intervalDateString = DateManager.shared.dateToString(interval)
    try container.encode(intervalDateString, forKey: .interval)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ProviderServiceJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    providerId = try container.decode(Int.self, forKey: .providerId)
    serviceId = try container.decode(Int.self, forKey: .serviceId)
    addressId = try container.decode(Int.self, forKey: .addressId)
    price = try container.decode(Double.self, forKey: .price)
    description = try container.decode(String.self, forKey: .description)

    let dateString = try container.decode(String.self, forKey: .interval)
    
    interval = DateManager.shared.stringToDate(dateString)
  }
}
