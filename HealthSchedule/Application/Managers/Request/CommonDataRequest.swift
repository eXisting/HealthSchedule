//
//  CommonDataRequest.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class CommonDataRequest {
  private let requestsManager = RequestManager()
  private let databaseManager = DataBaseManager.shared
  
  func getServices(_ completion: @escaping ([RemoteService]) -> Void) {
    // TODO
  }
  
  func getCities(_ completion: @escaping ([RemoteCity]) -> Void) {
    // TODO
  }
}
