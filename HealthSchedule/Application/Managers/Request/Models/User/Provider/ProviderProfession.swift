//
//  ProviderProfession.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProfessionJsonFields: String, CodingKey {
  case id
  case providerId = "provider_id"
  case professionId = "profession_id"
  case cityId = "city_id"
  case companyName = "company_name"
  
  case startAt = "start_at"
  case endAt = "end_at"
  
  case title
  case categoryId = "category_id"
}

struct RemoteProviderProfession {
  var id: Int
  var providerId: Int
  var professionId: Int
  var cityId: Int
  var companyName: String
  
  var startAt: Date
  var endAt: Date?
}

extension RemoteProviderProfession: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ProfessionJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(providerId, forKey: .providerId)
    try container.encode(professionId, forKey: .professionId)
    try container.encode(cityId, forKey: .cityId)
    try container.encode(companyName, forKey: .companyName)
    
    let startDateString = DateManager.shared.dateToString(startAt)
    try container.encode(startDateString, forKey: .startAt)
    
    guard let endDate = endAt else {
      try container.encode("", forKey: .endAt)
      return
    }
    
    let endDateString = DateManager.shared.dateToString(endDate)
    try container.encode(endDateString, forKey: .endAt)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ProfessionJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    providerId = try container.decode(Int.self, forKey: .providerId)
    professionId = try container.decode(Int.self, forKey: .professionId)
    cityId = try container.decode(Int.self, forKey: .cityId)
    companyName = try container.decode(String.self, forKey: .companyName)
    
    let startDateString = try container.decode(String.self, forKey: .startAt)
    startAt = DateManager.shared.stringToDate(startDateString)
    
    let endDateString = try? container.decode(String.self, forKey: .endAt)
    guard let endAtString = endDateString else {
      endAt = nil
      return
    }
    
    endAt = DateManager.shared.stringToDate(endAtString)
  }
}
