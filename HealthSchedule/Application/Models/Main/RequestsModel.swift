//
//  RequestsModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestsModel {
  private let userRequestController: CommonDataRequesting = UserDataRequest()
    
  func getRequests(_ callback: @escaping () -> Void) {
    userRequestController.getRequests {
      callback()
    }
  }
}
