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
  
  class func getListAsync<T: Decodable>(
    for type: T.Type,
    from endpoint: Endpoints,
    _ headers: Parser.JsonDictionary?,
    _ completion: @escaping ([T], ServerResponse) -> Void) {
    
    request.startSessionTask(buildEndpoint(endpoint.rawValue), params: headers) {
      (json, response) in
      let result = Parser.anyArrayToObjectArray(destination: T.self, json)
      completion(result, response)
    }
  }
  
  class func getAsync<T: Decodable>(
    for type: T.Type,
    from endpoint: Endpoints,
    _ params: Parser.JsonDictionary?,
    _ completion: @escaping (T?, ServerResponse) -> Void) {
    
    request.startSessionTask(buildEndpoint(endpoint.rawValue), params: params) {
      (json, response) in
      guard let initableObject = Parser.anyToObject(destination: T.self, json) else {
        completion(nil, response)
        return
      }
      
      completion(initableObject, response)
    }
  }
  
  class func getDataAsync(from url: String, _ completion: @escaping (Data?) -> Void) {
    guard let urlObject = URL(string: url) else {
      completion(nil)
      return
    }
    
    request.getData(from: urlObject, completion: completion)
  }
  
  // MARK: - POST
  
  class func postAsync(
    to url: String,
    as requestType: RequestType,
    _ data: Data?,
    _ params: Parser.JsonDictionary?,
    _ completion: @escaping (Any, ServerResponse) -> Void) {
    
    request.startSessionTask(buildEndpoint(url), requestType, body: data, params: params, completion: completion)
  }
  
  // MARK: - AUTHENTICATION
  
  class func signIn(userData: Data, _ completion: @escaping (RemoteUser?, ServerResponse) -> Void) {
    authorize(to: Endpoints.signIn.rawValue, userData, completion)
  }
  
  class func signUp(
    authType: UserType,
    userData: Data,
    _ completion: @escaping (RemoteUser?, ServerResponse) -> Void) {
    
    let isClientSignUp = authType == .client
    let endpoint = isClientSignUp ? Endpoints.signUpAsUser : Endpoints.signUpAsProvider
    
    authorize(to: endpoint.rawValue, userData, completion)
  }
}

// MARK: - HELPERS

extension RequestManager {
  
  private class func authorize(
    to url: String,
    _ data: Data?,
    _ completion: @escaping (RemoteUser?, ServerResponse) -> Void) {
    
    postAsync(to: url, as: .post, data, nil) {
      (tokenJson, tokenResponse) in
      if tokenResponse.error != nil {
        completion(nil, tokenResponse)
        return
      }
      
      rememberToken(from: tokenJson)
      
      getAsync(for: RemoteUser.self, from: Endpoints.user, sessionToken?.asParams(), completion)
    }
  }
  
  private class func buildEndpoint(_ route: String) -> String {
    return rootEndpoint + route
  }
  
  private class func rememberToken(from json: Any) {
    guard let token = Parser.anyToObject(destination: Token.self, json) else {
      return
    }
    print(token.token)
    sessionToken = token
  }
}
