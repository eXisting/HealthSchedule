//
//  UserDefaultsManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum UserDefaultsKeys: String {
  case sessionToken = "SessionToken"
  case sessionExpires = "SessionExpires"
  case userUniqueId = "UserUniqueId"
  case logutTriggered = "LogoutTriggered"
  case applicationLaunchedOnce = "LaunchedOnce"
}

extension Notification.Name {
  static let TokenDidExpired = Notification.Name(rawValue: "TokenExpired")
  static let LogoutCalled = Notification.Name(rawValue: "LogoutCalled")
}
