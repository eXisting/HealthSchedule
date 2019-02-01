//
//  Token.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum TokenJsonFields: String {
  case expires = "expires"
  case token = "token"
  case success = "success"
}

struct Token {
  var token: String?
  var expires: Int?
  var success: Bool?
}

extension Token: Codable {}
