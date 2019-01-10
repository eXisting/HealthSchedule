//
//  ContentViewCellRateable.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/10/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ContentViewCellRateable {
  var rate: Int? { get }
  
  func sendRate(rate: Int, forType cellType: ContentViewCellType)
}
