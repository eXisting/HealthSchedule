//
//  AuthProviding.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AuthProviding {
  // Get token, you need to get user internally in completion
  func fetchToken(from url: String, bodyData: RequestHandler.BodyDictionary, completion: @escaping RequestHandler.PostComplition)
}

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

extension Token: JsonInitiableModel {
  init?(json: [String: Any]) {
    token = json[TokenJsonFields.token.rawValue] as? String
    expires = json[TokenJsonFields.expires.rawValue] as? Int
    success = json[TokenJsonFields.success.rawValue] as? Bool
  }
}
