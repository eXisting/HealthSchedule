//
//  Provider.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProviderJsonFields: String, CodingKey {
  case address
}

struct Provider {
//  var professions: [ProviderProfession]
//  var certificates: [ProfileImage]
//  var services: [ProviderService]
  
//  var scheduleTemplate: [ScheduleWeekDay]
//  var scheduleExceptions: [ScheduleDateException]
  var address: Address?
}

extension Provider: Codable {}
