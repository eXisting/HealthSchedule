//
//  PasswordModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class PasswordModel {
  func save(with data: Parser.JsonDictionary, _ completion: @escaping (String) -> Void) {
    
    
    completion(ResponseStatus.success.rawValue)
  }
}
