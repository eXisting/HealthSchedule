//
//  ProviderProfession.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/30/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProviderProfessionJsonFields: String {
  case id = "id"
  case providerId = "provider_id"
  case professionId = "profession_id"
  case cityId = "city_id"
  case companyName = "company_name"
  case startAt = "start_at"
  case endAt = "end_at"
}

struct ProviderProfession {
  var id: Int
  var providerId: Int
  var professionId: Int
  var cityId: Int
  var companyName: String
  var startAt: Date
  var endAt: Date?
}

extension ProviderProfession: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[ProviderProfessionJsonFields.id.rawValue] as? Int,
      let providerId = json[ProviderProfessionJsonFields.providerId.rawValue] as? Int,
      let professionId = json[ProviderProfessionJsonFields.professionId.rawValue] as? Int,
      let cityId = json[ProviderProfessionJsonFields.cityId.rawValue] as? Int,
      let companyName = json[ProviderProfessionJsonFields.companyName.rawValue] as? String,
      let startAt = json[ProviderProfessionJsonFields.startAt.rawValue] as? Date,
      let endAt = json[ProviderProfessionJsonFields.endAt.rawValue] as? Date else {
        print("Cannot parse json fields in ProviderProfession.init!")
        return nil
    }
    
    self.id = id
    self.providerId = providerId
    self.professionId = professionId
    self.cityId = cityId
    self.companyName = companyName
    self.startAt = startAt
    self.endAt = endAt
  }
}

extension ProviderProfession: JsonConvertable {
  func asJson() -> Serializer.JsonDictionary {
    let formatter = DatesManager.shared.dateFormatter
    
    var endDate = ""
    if let end = endAt {
      endDate = formatter.string(from: end)
    }
    
    return [
      ProviderProfessionJsonFields.id.rawValue: String(id),
      ProviderProfessionJsonFields.providerId.rawValue: String(providerId),
      ProviderProfessionJsonFields.professionId.rawValue: String(providerId),
      ProviderProfessionJsonFields.cityId.rawValue: String(cityId),
      ProviderProfessionJsonFields.companyName.rawValue: companyName,
      ProviderProfessionJsonFields.startAt.rawValue: formatter.string(from: startAt),
      ProviderProfessionJsonFields.endAt.rawValue: endDate
    ]
  }
}
