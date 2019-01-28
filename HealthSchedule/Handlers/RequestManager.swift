//
//  RequestManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum Endpoints: String {
  case allCities = "/api/cities"
  case allProfessions = "/api/category/doctors/professions"
  
  case signIn = "/api/login"
  case signUpAsUser = "/api/register/user"
  case signUpAsProvider = "/api/register/provider"
}

class RequestManager {
  static let endpoint = "http://127.0.0.1:8000"
  
  private static let listRequest: ListsRequesting = RequestHandler.shared
  
  private class func buildEndpoint(_ route: String) -> String {
    return endpoint + route
  }
  
  class func getListAsyncFor<T: JsonInitiableModel>(type: T.Type, from endpoint: Endpoints, _ complition: @escaping ([T]) -> Void) {
    listRequest.getAsync(from: buildEndpoint(endpoint.rawValue)) { json in
      var result = [T]()
      
      for element in json {
        guard let parseableJson = element as? [String:Any] else {
          print("Cannot cast to [String:Any] in getCitiesAsync")
          continue
        }
        
        guard let initableObject = T(json: parseableJson) else {
          continue
        }
        
        result.append(initableObject)
      }
      
      complition(result)
    }
  }
}
