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
  
  class func getListAsync<T: Decodable>(for type: T.Type, from endpoint: Endpoints, _ headers: Parser.JsonDictionary?, _ completion: @escaping ([T], ServerResponse) -> Void) {
    request.getAsync(from: buildEndpoint(endpoint.rawValue), headers) { (json, response) in
      let result = Parser.anyArrayToObjectArray(destination: T.self, json)
      completion(result, response)
    }
  }
  
  class func getAsync<T: Decodable>(for type: T.Type, from endpoint: Endpoints, _ params: Parser.JsonDictionary?, _ completion: @escaping (T?, ServerResponse) -> Void) {
    request.getAsync(from: buildEndpoint(endpoint.rawValue), params) { (json, response) in
      guard let initableObject = Parser.anyToObject(destination: T.self, json) else {
        completion(nil, response)
        return
      }
      
      completion(initableObject, response)
    }
  }
  
  // MARK: - POST
  
  class func postAsync(to url: String, as requestType: RequestType, _ data: Data?, _ params: Parser.JsonDictionary?, _ completion: @escaping (Any, ServerResponse) -> Void) {
    request.postAsync(to: buildEndpoint(url), type: requestType, body: data, params: params) { (json, response) in
      completion(json, response)
    }
  }
  
  // MARK: - AUTHENTICATION
  
  class func signIn(userData: Data, _ completion: @escaping (User?, ServerResponse) -> Void) {
    postAsync(to: Endpoints.signIn.rawValue, as: .post, userData, nil) { (tokenJson, tokenResponse) in
      if tokenResponse.error != nil {
        completion(nil, tokenResponse)
        return
      }
      
      rememberToken(from: tokenJson)
      
      getAsync(for: User.self, from: Endpoints.user, sessionToken?.asParams()) { (user, response) in
        completion(user, response)
      }
    }
  }
  
  class func signUp(authType: UserType, userData: Data, _ completion: @escaping (User?, ServerResponse) -> Void) {
    let isClientSignUp = authType == .client
    
    let endpoint = isClientSignUp ? Endpoints.signUpAsUser : Endpoints.signUpAsProvider
    
    postAsync(to: endpoint.rawValue, as: .post, userData, nil) { (json, response) in
      print(json)
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
