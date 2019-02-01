//
//  Provider.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct Provider {
  var professions: [ProviderProfession]
  var certificates: [ProfileImage]
  var services: [ProviderService]
  
  var scheduleTemplate: [ScheduleWeekDay]
  var scheduleExceptions: [ScheduleDateException]
  
  init?(json: [String: Any]) {
    // TODO: Init
    professions = []
    certificates = []
    services = []
    scheduleTemplate = []
    scheduleExceptions = []
  }
}
