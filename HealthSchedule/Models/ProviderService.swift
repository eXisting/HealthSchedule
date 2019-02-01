//
//  ProviderService.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProviderServiceJsonFields: String {
  case id = "id"
  case providerId = "provider_id"
  case serviceId = "service_id"
  case addressId = "address_id"
  case price = "price"
  case description = "description"
  case interval = "interval"
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

extension ProviderService: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[ProviderServiceJsonFields.id.rawValue] as? Int,
      let providerId = json[ProviderServiceJsonFields.providerId.rawValue] as? Int,
      let serviceId = json[ProviderServiceJsonFields.serviceId.rawValue] as? Int,
      let addressId = json[ProviderServiceJsonFields.addressId.rawValue] as? Int,
      let price = json[ProviderServiceJsonFields.price.rawValue] as? Double,
      let description = json[ProviderServiceJsonFields.description.rawValue] as? String,
      let interval = json[ProviderServiceJsonFields.interval.rawValue] as? Date else {
        print("Cannot parse json fields in ProviderService.init!")
        return nil
    }
    
    self.id = id
    self.providerId = providerId
    self.serviceId = serviceId
    self.addressId = addressId
    self.price = price
    self.description = description
    self.interval = interval
  }
}

extension ProviderService: JsonConvertable {
  func asJson() -> Parser.JsonDictionary {
    return [
      ProviderServiceJsonFields.id.rawValue: String(id),
      ProviderServiceJsonFields.providerId.rawValue: String(providerId),
      ProviderServiceJsonFields.serviceId.rawValue: String(serviceId),
      ProviderServiceJsonFields.addressId.rawValue: String(addressId),
      ProviderServiceJsonFields.price.rawValue: String(price),
      ProviderServiceJsonFields.description.rawValue: description,
      ProviderServiceJsonFields.interval.rawValue: DatesManager.shared.dateFormatter.string(from: interval)
    ]
  }
}
