//
//  ProfileImage.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProfileImageJsonFields: String, CodingKey {
  case id
  case userId = "user_id"
  case url = "image_path"
}

struct ProfileImage {
  var id: Int
  var userId: Int
  var url: String?
}

extension ProfileImage: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: ProfileImageJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(userId, forKey: .userId)
    try container.encode(url, forKey: .url)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ProfileImageJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    userId = try container.decode(Int.self, forKey: .userId)
    url = try container.decode(String.self, forKey: .url)
  }
}

