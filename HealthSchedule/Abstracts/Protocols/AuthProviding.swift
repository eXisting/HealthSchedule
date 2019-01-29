//
//  AuthProviding.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AuthProviding {
  // Get token
  func login(to url: String, params: RequestHandler.JsonDictionary?, bodyData: RequestHandler.JsonDictionary, completion: @escaping RequestHandler.PostComplition)
  
  func singUp()
  func singIn()
}

enum TokenJsonFields: String {
  case expires = "expires"
  case token = "token"
}

struct Token {
  var expires: Int
  var token: String
}

extension Token: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let expires = json[TokenJsonFields.expires.rawValue] as? Int,
      let token = json[TokenJsonFields.token.rawValue] as? String else {
        print("Cannot parse json fields in Token.init!")
        return nil
    }
    
    self.expires = expires
    self.token = token
  }
}
