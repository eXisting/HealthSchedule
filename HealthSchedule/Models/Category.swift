//
//  Category.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct Category {
  var id: Int
  var categoryId: Int
  var name: String
  var title: String
}

extension Category: Codable {}

extension Category: PrintableObject {
  func getViewableString() -> String {
    return title
  }
}
