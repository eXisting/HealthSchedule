//
//  Profession.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProfessionJsonFields: String {
  case id = "id"
  case categoryId = "category_id"
  case name = "name"
  case title = "title"
}

struct Profession {
  var id: Int
  var categoryId: Int
  var name: String
  var title: String
}

extension Profession: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[ProfessionJsonFields.id.rawValue] as? Int,
      let categoryId = json[ProfessionJsonFields.categoryId.rawValue] as? Int,
      let name = json[ProfessionJsonFields.name.rawValue] as? String,
      let title = json[ProfessionJsonFields.title.rawValue] as? String else {
        print("Cannot parse json fields in Profession.init!")
        return nil
    }
    
    self.id = id
    self.categoryId = categoryId
    self.name = name
    self.title = title
  }
}

extension Profession: PrintableObject {
  func getViewableString() -> String {
    return title
  }
}
