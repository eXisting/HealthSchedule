//
//  CreateProviderServiceModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class CreateProviderServiceModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  
  func createRequest(_ completion: @escaping (String) -> Void) {
    requestManager.createProviderService(with: [:], completion: completion)
  }
}
