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
  private let databaseManager = DataBaseManager.shared
  
  var serviceId: Int?
  var cityId: Int?
  
  var services: [Service] = []
  
  // TODO:
  // LOAD FROM DB FIRST AND ONLY IN CASE WHEN THERE WILL BE EMPTY RESULT RELOAD FROM NETWORK
    
  func getCities(_ completion: @escaping ([City]) -> Void) {
    commonDataRequestController.getCities {
      [weak self] status in
      if status == ResponseStatus.success.rawValue {
        completion(self!.databaseManager.getCties())
      }
    }
  }
  
  func startLoadServices(_ completion: @escaping () -> Void) {
    guard let id = cityId else {
      return
    }
    
    commonDataRequestController.getServices(for: id) {
      [weak self] status in
      if status == ResponseStatus.success.rawValue {
        self!.services = self!.databaseManager.getServices()
        completion()
      }
    }
  }
}
