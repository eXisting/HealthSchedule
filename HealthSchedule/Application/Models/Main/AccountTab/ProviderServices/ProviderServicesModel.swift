//
//  ProviderServicesModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServicesModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  
  func loadServices(_ completion: @escaping () -> Void) {
    requestManager.getProviderServices { response in
      completion()
    }
  }
}
