//
//  RequestManager.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestManager {
  static private(set) var sessionToken = Token()
  
  // private let rootEndpoint = "http://127.0.0.1:8000"
  
  // C9 server endpoint
  private let rootEndpoint = "https://schedule-exist228.c9users.io"
  
  private let sessionHandler = UrlSessionHandler()
  
  // MARK: - GET
  
  func getListAsync<T: Decodable>(
    for type: T.Type,
    from endpoint: Endpoints,
    _ headers: Parser.JsonDictionary?,
    _ completion: @escaping ([T], ServerResponse) -> Void) {
    
    sessionHandler.startSessionTask(buildEndpoint(endpoint.rawValue), params: headers) {
      (json, response) in
      let result = Parser.anyArrayToObjectArray(destination: T.self, json)
      completion(result, response)
    }
  }
  
  func getAsync<T: Decodable>(
    for type: T.Type,
    from endpoint: Endpoints,
    _ params: Parser.JsonDictionary?,
    _ completion: @escaping (T?, ServerResponse) -> Void) {
    
    sessionHandler.startSessionTask(buildEndpoint(endpoint.rawValue), params: params) {
      (json, response) in
      guard let initableObject = Parser.anyToObject(destination: T.self, json) else {
        completion(nil, response)
        return
      }
      
      completion(initableObject, response)
    }
  }
  
  func getDataAsync(from url: String, _ completion: @escaping (Data?) -> Void) {
    guard let urlObject = URL(string: url) else {
      completion(nil)
      return
    }
    
    sessionHandler.getData(from: urlObject, completion: completion)
  }
  
  // MARK: - POST
  
  func postAsync(
    to url: String,
    as requestType: RequestType,
    _ data: Parser.JsonDictionary?,
    _ params: Parser.JsonDictionary?,
    _ completion: @escaping (Any, ServerResponse) -> Void) {
    
    sessionHandler.startSessionTask(buildEndpoint(url), requestType, body: data, params: params, completion: completion)
  }
  
  // MARK: - AUTHENTICATION
  
  func signIn(userData: Parser.JsonDictionary, _ completion: @escaping (RemoteUser?, ServerResponse) -> Void) {
    authorize(to: Endpoints.signIn.rawValue, userData, completion)
  }
  
  func signUp(
    authType: UserType,
    userData: Parser.JsonDictionary,
    _ completion: @escaping (RemoteUser?, ServerResponse) -> Void) {
    
    let isClientSignUp = authType == .client
    let endpoint = isClientSignUp ? Endpoints.signUpAsUser : Endpoints.signUpAsProvider
    
    authorize(to: endpoint.rawValue, userData, completion)
  }
}

// MARK: - HELPERS

extension RequestManager {
  
  private func authorize(
    to url: String,
    _ data: Parser.JsonDictionary?,
    _ completion: @escaping (RemoteUser?, ServerResponse) -> Void) {
    
    postAsync(to: url, as: .post, data, nil) {
      [weak self] (tokenJson, tokenResponse) in
      if tokenResponse.error != nil {
        completion(nil, tokenResponse)
        return
      }
      
      self?.rememberToken(from: tokenJson)
      
      self?.getAsync(for: RemoteUser.self, from: Endpoints.user, RequestManager.sessionToken.asParams()) {
        (userObject, serverResponse) in
        
        if let user = userObject {
          UserDefaults.standard.set(user.id, forKey: UserDefaultsKeys.userUniqueId.rawValue)
        }
        
        completion(userObject, serverResponse)
      }
    }
  }
  
  static func rememberTokenFromUserDefualts() {
    RequestManager.sessionToken.token = UserDefaults.standard.string(forKey: UserDefaultsKeys.sessionToken.rawValue)
  }
  
  private func buildEndpoint(_ route: String) -> String {
    return rootEndpoint + route
  }
  
  private func rememberToken(from json: Any) {
    guard let token = Parser.anyToObject(destination: Token.self, json) else {
      return
    }
    
    let expireDate = DateManager.shared.getExpirationDate(expires: token.expires!)
    UserDefaults.standard.set(token.token, forKey: UserDefaultsKeys.sessionToken.rawValue)
    UserDefaults.standard.set(expireDate, forKey: UserDefaultsKeys.sessionExpires.rawValue)
    print(token.token)
    RequestManager.sessionToken = token
  }
}
