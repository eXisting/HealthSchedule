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
  
  static func isValid() -> Bool {
    guard let expirationData = UserDefaults.standard.object(forKey: UserDefaultsKeys.sessionExpires.rawValue) as? Date else {
      return false
    }
    
    return expirationData > Date()
  }
  
  static func clear() {
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sessionToken.rawValue)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sessionExpires.rawValue)
    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userUniqueId.rawValue)
  }
}

extension Token: Codable {}
