//
//  ServicesModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ServicesModel {
  private let commonDataRequestController = CommonDataRequest()
  
  var serviceId: Int?
  var cityId: Int?
  
  var services: [RemoteService] = []
      
  func getCities() -> [City] {
    return DataBaseManager.shared.fetchRequestsHandler.getCties(context: DataBaseManager.shared.mainContext)
  }
  
  func startLoadServices(_ completion: @escaping () -> Void) {
    guard let id = cityId else { return }
    
    commonDataRequestController.getServices(for: id) {
      [weak self] services in
      self!.services = services
      completion()
    }
  }
}
