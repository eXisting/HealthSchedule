//
//  Service.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ServiceJsonFields: String, CodingKey {
  case id
  case title
  case name
  case professionId = "profession_id"
}

struct RemoteService {
  var id: Int
  var professionId: Int
  var name: String
  var title: String
}

extension RemoteService: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ServiceJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(title, forKey: .title)
    try container.encode(professionId, forKey: .professionId)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ServiceJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    title = try container.decode(String.self, forKey: .title)
    professionId = try container.decode(Int.self, forKey: .professionId)
  }
}
