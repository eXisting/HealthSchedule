//
//  RemoteImage.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/29/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum RemoteImageJsonFields: String {
  case id = "id"
  case userId = "user_id"
  case url = "image_path"
}

struct RemoteImage {
  var id: Int
  var userId: Int
  var url: String
}

extension RemoteImage: JsonInitiableModel {
  init?(json: [String : Any]) {
    guard let id = json[RemoteImageJsonFields.id.rawValue] as? Int,
      let userId = json[RemoteImageJsonFields.userId.rawValue] as? Int,
      let url = json[RemoteImageJsonFields.url.rawValue] as? String else {
        print("Cannot parse json fields in RemoteImage.init!")
        return nil
    }
  
    self.id = id
    self.userId = userId
    self.url = url
  }
}
