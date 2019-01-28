//
//  City.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum CityJsonFields: String {
  case id = "id"
  case name = "name"
  case title = "title"
}

struct City {
  var id: String
  var name: String
  var title: String
}

extension City {
  init?(json: [String: Any]) {
    guard let id = json[CityJsonFields.id.rawValue] as? String,
      let name = json[CityJsonFields.name.rawValue] as? String,
      let title = json[CityJsonFields.title.rawValue] as? String else {
        print("Cannot parse json fields in City.init!")
        return nil
    }
    
    self.id = id
    self.name = name
    self.title = title
  }
}
