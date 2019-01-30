//
//  Category.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum CategoryJsonFields: String {
  case id = "id"
  case categoryId = "category_id"
  case name = "name"
  case title = "title"
}

struct Category {
  var id: Int
  var categoryId: Int
  var name: String
  var title: String
}

extension Category: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[CategoryJsonFields.id.rawValue] as? Int,
      let categoryId = json[CategoryJsonFields.categoryId.rawValue] as? Int,
      let name = json[CategoryJsonFields.name.rawValue] as? String,
      let title = json[CategoryJsonFields.title.rawValue] as? String else {
        print("Cannot parse json fields in Category.init!")
        return nil
    }
    
    self.id = id
    self.categoryId = categoryId
    self.name = name
    self.title = title
  }
}

extension Category: PrintableObject {
  func getViewableString() -> String {
    return title
  }
}
