//
//  Profession.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/26/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct RemoteProfession: Codable {
  var id: Int
  var title: String
  var categoryId: Int
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ProfessionJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    categoryId = try container.decode(Int.self, forKey: .categoryId)
    title = try container.decode(String.self, forKey: .title)
  }
}
