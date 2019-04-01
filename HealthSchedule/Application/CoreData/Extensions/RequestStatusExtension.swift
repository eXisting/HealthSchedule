//
//  RequestStatusExtension.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import CoreData

extension Request {
  func status2RequestStatusName() -> RequestStatusName {
    return ReqeustStatus.statusValue2RequestStatusName(value: Int(status))
  }
}
