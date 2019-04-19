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
  
  func getImage(from url: String, completion: @escaping (Data) -> Void) {
    requestsManager.getDataAsync(from: url) { (data) in
      guard let imageData = data else {
        return
      }
      
      completion(imageData)
    }
  }
  
  func getServices(for cityId: Int, _ completion: @escaping ([RemoteService]) -> Void) {
    var params = RequestManager.sessionToken.asParams()
    params[UserJsonFields.cityId.rawValue] = String(cityId)
    
    requestsManager.getListAsync(for: RemoteService.self, from: .services, params) {
      (services, response) in
      
      if let _ = response.error {
        completion([])
        return
      }
      
      completion(services)
    }
  }
  
  func getAllServices(_ completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteService.self, from: .allServices, RequestManager.sessionToken.asParams()) {
      [weak self] (services, response) in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      DispatchQueue.global(qos: .userInteractive).async {
        self!.databaseManager.insertUpdateServices(from: services)
        completion(ResponseStatus.success.rawValue)
      }
    }
  }
  
  func getCities(_ completion: @escaping (String) -> Void) {
    requestsManager.getListAsync(for: RemoteCity.self, from: .allCities, nil) {
      [weak self] (cities, response) in
      
      if let error = response.error {
        completion(error)
        return
      }
      
      DispatchQueue.global(qos: .userInteractive).async {
        self?.databaseManager.insertUpdateCities(from: cities)
        completion(ResponseStatus.success.rawValue)
      }
    }
  }
  
  func getAvailableTimesList(_ data: Parser.JsonDictionary, _ completion: @escaping (RemoteAvailableTimeContainer?) -> Void) {
    let getParams = data.merging(RequestManager.sessionToken.asParams(), uniquingKeysWith: { first,second in return first })
    
    requestsManager.getAvailableTimes(params: getParams) {
      object, response in
      if response != ResponseStatus.success.rawValue {
        completion(nil)
        return
      }
      
      // NOTE: Core data mocked until either:
      // 1. Server will send push notification about data changing so app should download new data in background and save it by hash
      // 2. Implement service which will observ data on server and compare it with stored data, but still need an API request
      // for now it's just returning obtained data
      
      completion(object)
    }
  }
}
