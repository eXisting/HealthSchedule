//
//  RequestManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestManager {
  static let rootEndpoint = "http://127.0.0.1:8000"
  
  private static let request = UrlSessionHandler.shared
  
  static private(set) var sessionToken: Token?
  
  // MARK: - GET
  
  class func getListAsyncFor<T: Decodable>(type: T.Type, from endpoint: Endpoints, _ headers: Parser.JsonDictionary?, _ completion: @escaping ([T], ResponseStatus) -> Void) {
    request.getAsync(from: buildEndpoint(endpoint.rawValue), headers) { (json, status) in
      let result = Parser.anyArrayToObjectArray(destination: T.self, json)
      completion(result, status)
    }
  }
  
  class func getAsyncFor<T: Decodable>(type: T.Type, from endpoint: Endpoints, _ params: Parser.JsonDictionary?, _ completion: @escaping (T?, ResponseStatus) -> Void) {
    request.getAsync(from: buildEndpoint(endpoint.rawValue), params) { (json, status) in
      switch status {
        case .ok:
          guard let initableObject = Parser.anyToObject(destination: T.self, json) else {
            completion(nil, .applicationError)
            return
          }
          
          completion(initableObject, .ok)
          return
        
        default:
          completion(nil, status)
          break
      }
    }
  }
  
  // MARK: - POST
  
  class func postAsync(to url: String, as requestType: RequestType, _ data: Data?, _ params: Parser.JsonDictionary?, _ completion: @escaping (Any, ResponseStatus) -> Void) {
    request.postAsync(to: buildEndpoint(url), type: requestType, body: data, params: params) { (json, status) in
      completion(json, status)
    }
  }
  
  // MARK: - AUTHENTICATION
  
  class func signIn(userData: Data, _ completion: @escaping (User?, ResponseStatus) -> Void) {
    postAsync(to: Endpoints.signIn.rawValue, as: .post, userData, nil) { (json, status) in
      rememberToken(from: json)
      
      getAsyncFor(type: User.self, from: Endpoints.user, sessionToken?.asParams()) { (user, status) in
        guard let user = user else {
          completion(nil, status)
          return
        }
        
        completion(user, .ok)
      }
    }
  }
  
  class func signUp(authType: UserType, userData: Data, _ completion: @escaping (User?, ResponseStatus) -> Void) {
    let isClientSignUp = authType == .client
    
    let endpoint = isClientSignUp ? Endpoints.signUpAsUser : Endpoints.signUpAsProvider
    
    postAsync(to: endpoint.rawValue, as: .post, userData, nil) { (json, status) in
      print(status)
    }
  }
}

// MARK: - HELPERS

extension RequestManager {
  private class func buildEndpoint(_ route: String) -> String {
    return rootEndpoint + route
  }
  
  private class func rememberToken(from json: Any) {
    guard let token = Parser.anyToObject(destination: Token.self, json) else {
      return
    }
    
    sessionToken = token
  }
}
