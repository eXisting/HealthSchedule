//
//  Service.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum RemoteServiceJsonFields: String, CodingKey {
  case id
  case title
  case professionId = "profession_id"
}

struct RemoteService: Codable {
  var id: Int
  var title: String
  var professionId: Int
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: RemoteServiceJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    professionId = try container.decode(Int.self, forKey: .professionId)
  }
}
