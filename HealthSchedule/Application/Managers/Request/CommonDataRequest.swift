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
  
  func getServices(for cityId: Int, _ completion: @escaping ([RemoteService]) -> Void) {
    // TODO
  }
  
  func getCities(_ completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteCity.self, from: .allCities, nil) {
      [weak self] (cities, response) in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      if self?.databaseManager.getCties().count == 0 {
        self?.databaseManager.insertCities(from: cities)
      }
      
      completion(ResponseStatus.success.rawValue)
    }
  }
}
