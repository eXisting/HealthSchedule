//
//  DateOperationsHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/31/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class DateOperationsHandler {
  static let shared = DateOperationsHandler()
  
  let dateFormatter = DateFormatter()
  
  private init() {
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
  }
}
