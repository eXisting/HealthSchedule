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
  
  func getServices(for cityId: Int, _ completion: @escaping (String) -> Void) {
    var params = RequestManager.sessionToken.asParams()
    params[UserJsonFields.cityId.rawValue] = String(cityId)
    
    requestsManager.getListAsync(for: RemoteService.self, from: .allServices, params) {
      [weak self] (services, response) in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      if self?.databaseManager.getServices().count == 0 {
        self?.databaseManager.insertServices(from: services)
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func getCities(_ completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteCity.self, from: .allCities, nil) {
      [weak self] (cities, response) in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      self?.databaseManager.insertUpdateCities(from: cities)
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}
