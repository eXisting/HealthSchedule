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
  
  case user = "/api/user"
  case provider = "/api/provider"

  case signUpAsUser = "/api/register/user"
  case signUpAsProvider = "/api/register/provider"
}

class RequestManager {
  static let rootEndpoint = "http://127.0.0.1:8000"
  
  private static let getRequest: GetRequesting = RequestHandler.shared
  private static let authRequests: AuthProviding = RequestHandler.shared
  
  private class func buildEndpoint(_ route: String) -> String {
    return rootEndpoint + route
  }
  
  class func getListAsyncFor<T: JsonInitiableModel>(type: T.Type, from endpoint: Endpoints, _ headers: RequestHandler.JsonDictionary?, _ complition: @escaping ([T]) -> Void) {
    getRequest.getAsync(from: buildEndpoint(endpoint.rawValue), headers) { json in
      var result = [T]()
      
      for element in json {
        guard let parseableJson = element as? [String:Any] else {
          print("Cannot cast to [String:Any] in getListAsyncFor")
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
  
  class func getAsyncFor<T: JsonInitiableModel>(type: T.Type, from endpoint: Endpoints, _ params: RequestHandler.JsonDictionary?, _ complition: @escaping (T) -> Void) {
    getRequest.getObjectAsync(from: buildEndpoint(endpoint.rawValue), params) { json in
      guard let parseableJson = json as? [String:Any] else {
        print("Cannot cast to [String:Any] in getAsyncFor")
        return
      }

      guard let initableObject = T(json: parseableJson) else {
        print("Cannot init object in getAsyncFor")
        return
      }

      complition(initableObject)
    }
  }
  
  class func signIn(authType: UserType, body: RequestHandler.JsonDictionary, _ complition: @escaping RequestHandler.PostComplition) {
    authRequests.login(to: buildEndpoint(Endpoints.signIn.rawValue), params: nil, bodyData: body) { (data, error) in
      guard let tokenJson = data as? [String:Any] else {
        print("Token has wrong format")
        return
      }
      
      var tokenHeaders: RequestHandler.JsonDictionary = [:]
      guard let tokenObject = Token(json: tokenJson) else {
        print("Cannot init token object in signIn")
        return
      }
      
      tokenHeaders[TokenJsonFields.token.rawValue] = tokenObject.token

      let signInEndpoint = authType == .client ? Endpoints.user : Endpoints.provider
      
      getAsyncFor(type: User.self, from: signInEndpoint, tokenHeaders) { user in
        // TODO: manage two types of authentications
        complition((user, nil))
      }
    }
  }
}
