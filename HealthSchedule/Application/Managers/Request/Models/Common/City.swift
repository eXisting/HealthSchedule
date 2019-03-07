//
//  City.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct RemoteCity {
  var id: Int
  var name: String
  var title: String
}

extension RemoteCity: Codable {}
