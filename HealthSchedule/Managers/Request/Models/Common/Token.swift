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
  
  func asParams() -> Parser.JsonDictionary {
    guard let tokenValue = token else {
      return [TokenJsonFields.token.rawValue: ""]
    }
    
    return [TokenJsonFields.token.rawValue: tokenValue]
  }
}

extension Token: Codable {}
