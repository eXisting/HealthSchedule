//
//  Service.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct RemoteService {
  var id: Int
  var name: String
  var title: String
}

extension RemoteService: Codable {}
