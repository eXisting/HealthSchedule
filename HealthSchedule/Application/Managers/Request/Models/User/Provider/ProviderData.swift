//
//  Provider.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProviderDataJsonFields: String, CodingKey {
  case address
  case professions
}

struct ProviderData {
  var professions: [RemoteProviderProfession] = []
  var certificates: [ProfileImage] = []
  var services: [RemoteProviderService] = []
  
  var scheduleTemplate: [RemoteScheduleTemplateDay] = []
  var scheduleExceptions: [RemoteScheduleDateException] = []
  var address: RemoteAddress?
  
  init() {}
}

extension ProviderData: Codable {}
