//
//  HistoryNavigatonController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestNavigationController: UINavigationController {
  private let requestCardController = RequestCardViewController()
  
  func pushRequestDetail(_ request: RemoteRequest) {
    pushViewController(requestCardController, animated: true)
  }
  
  func popFromCard() {
    popViewController(animated: true)
  }
}
