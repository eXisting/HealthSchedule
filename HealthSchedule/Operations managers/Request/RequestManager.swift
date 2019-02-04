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
  
  private static let request: Requesting = UrlSessionHandler.shared
  private static let authRequests: AuthProviding = UrlSessionHandler.shared
  
  static private(set) var sessionToken: Token?
  
  // MARK: - GET
  
  class func getListAsyncFor<T: Decodable>(type: T.Type, from endpoint: Endpoints, _ headers: Parser.JsonDictionary?, _ completion: @escaping ([T]) -> Void) {
    request.getAsync(from: buildEndpoint(endpoint.rawValue), headers) { json in
      let result = Parser.anyArrayToObjectArray(destination: T.self, json)
      
      completion(result)
    }
  }
  
  class func getAsyncFor<T: Decodable>(type: T.Type, from endpoint: Endpoints, _ params: Parser.JsonDictionary?, _ completion: @escaping (T) -> Void) {
    request.getAsync(from: buildEndpoint(endpoint.rawValue), params) { json in
      guard let initableObject = Parser.anyToObject(destination: T.self, json) else {
        return
      }

      completion(initableObject)
    }
  }
  
  // MARK: - POST
  
  class func postAsync(to url: String, as type: RequestType, _ data: Data?, _ params: Parser.JsonDictionary?, _ completion: @escaping (Status) -> Void) {
    request.postAsync(to: buildEndpoint(url), as: type, data, params) { (data, error) in
      completion(error == nil ? .ok : .failure)
    }
  }
  
  // MARK: - AUTHENTICATION
  
  class func signIn(userData: Data, _ completion: @escaping UrlSessionHandler.Usercompletion) {
    authRequests.getToken(from: buildEndpoint(Endpoints.signIn.rawValue), body: userData) { (data, error) in
      getAsyncFor(type: User.self, from: .user, rememberTokenFrom(data).asParams()) { user in
        completion((user, nil, nil))
      }
    }
  }
  
  class func signUp(authType: UserType, userData: Data, _ completion: @escaping UrlSessionHandler.Usercompletion) {
    let isClientSignUp = authType == .client
    
    let endpoint = isClientSignUp ? Endpoints.signUpAsUser : Endpoints.signUpAsProvider
    
    authRequests.getToken(from: buildEndpoint(endpoint.rawValue), body: userData) { (data, error) in
      getAsyncFor(type: User.self, from: .user, rememberTokenFrom(data).asParams()) { user in
        completion((user, !isClientSignUp ? .accountModeration : nil, nil))
      }
    }
  }
}

extension RequestManager {
  private class func buildEndpoint(_ route: String) -> String {
    return rootEndpoint + route
  }
  
  private class func rememberTokenFrom(_ data: Data) -> Token {
    guard let token = Serializer.decodeDataInto(type: Token.self, data) else {
      return Token()
    }
    
    sessionToken = token
    return token
  }
}
