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
  var dataSource = ProviderServicesDataSource()
  
  func getStoredServices(_ callback: @escaping (String) -> Void) {
    guard let _ = DataBaseManager.shared.providerServicesFrc.fetchedObjects else { return }
    callback(ResponseStatus.success.rawValue)
  }
  
  func loadServices(_ completion: @escaping (String) -> Void) {
    requestManager.getProviderServices(completion: completion)
  }
}
