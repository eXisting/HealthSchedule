//
//  ServerException.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/7/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ServerErrorJsonFields: String {
  case error
}

struct ServerResponse {
  var error: String?
  
  init() {}
  
  init(_ error: String?) {
    self.error = error
  }
}

extension ServerResponse: Codable {}

enum ResponseStatus: String {
  case success
  case invalidData = "Passed data is invalid!"
  case applicationError = "Applicaton error! Contact developer"
  
  case cannotProceed = "Server cannot proceed your request!"
  case serverError = "Server error!"
}
