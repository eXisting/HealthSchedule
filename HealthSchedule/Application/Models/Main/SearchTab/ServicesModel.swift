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
      
  func getCities(_ completion: @escaping ([City]) -> Void) {
    let cities = DataBaseManager.shared.fetchRequestsHandler.getCties(context: DataBaseManager.shared.mainContext)
    if cities.count > 1 {
      completion(cities)
      return
    }
    
    commonDataRequestController.getCities { status in
      if status != ResponseStatus.success.rawValue { return }
        completion(DataBaseManager.shared.fetchRequestsHandler.getCties(context: DataBaseManager.shared.mainContext))
    }
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
