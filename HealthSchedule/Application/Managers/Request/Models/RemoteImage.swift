//
//  RemoteImage.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/29/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum RemoteImageJsonFields: String, CodingKey {
  case id
  case userId = "user_id"
  case url = "image_path"
}

struct ProfileImage {
  var id: Int
  var userId: Int
  var url: String
}

extension ProfileImage: Codable {
  
}
