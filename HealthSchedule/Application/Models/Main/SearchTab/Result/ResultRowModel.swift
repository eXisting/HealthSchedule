//
//  ResultRowModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct ResultRowModel {
  var rowHeight: CGFloat = 70
  
  var time: Date
  var userIds: [Int]
  
  init(_ pair: RemoteAvailableTimeContainer.TimeIdsPair) {
    time = pair.0
    userIds = pair.1
  }
  
  mutating func changeHeight(to height: CGFloat) {
    rowHeight = height
  }
}
