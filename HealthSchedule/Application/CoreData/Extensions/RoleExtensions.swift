//
//  RoleExtensions.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import CoreData

extension Role {
  func role2UserTypeName() -> UserTypeName {
    switch self.id {
    case 1:
      return UserTypeName.provider
    case 2:
      return UserTypeName.client
    default:
      return UserTypeName.unknown
    }
  }
}
