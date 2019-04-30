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
    _ params: Parser.JsonDictionary?,
    _ completion: @escaping ([T], ServerResponse) -> Void) {
    
    let request = sessionHandler.buildRequest(for: .http, buildEndpoint(endpoint.rawValue), .get, params)
    
    sessionHandler.startSessionTask(with: request) {
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
    getAsync(for: type, from: endpoint.rawValue, params, completion)
  }
  
  func getAsync<T: Decodable>(
    for type: T.Type,
    from endpoint: String,
    _ params: Parser.JsonDictionary?,
    _ completion: @escaping (T?, ServerResponse) -> Void) {
    
    let request = sessionHandler.buildRequest(for: .http, buildEndpoint(endpoint), .get, params)
    
    sessionHandler.startSessionTask(with: request) {
      (json, response) in
      guard let initableObject = Parser.anyToObject(destination: T.self, json) else {
        completion(nil, response)
        return
      }
      
      completion(initableObject, response)
    }
  }
  
  // Cannot be parsed using regular serialization
  func getAvailableTimes(params: Parser.JsonDictionary, _ completion: @escaping (RemoteAvailableTimeContainer?, String) -> Void ) {
    let endpoint = buildEndpoint(Endpoints.availableProvidersByInterval.rawValue)
    
    let request = sessionHandler.buildRequest(for: .http, endpoint, .get, params)
    
    sessionHandler.startSessionTask(with: request) {
      json, response in
      if let error = response.error {
        completion(nil, error)
        return
      }
      
      completion(RemoteAvailableTimeContainer(json: json), ResponseStatus.success.rawValue)
    }
  }
  
  func getDataAsync(from url: String, _ laravelRelated: Bool = true, _ completion: @escaping (Data?) -> Void) {
    let endpoint = laravelRelated ? buildEndpoint(url) : url
    
    guard let urlObject = URL(string: endpoint) else {
      completion(nil)
      return
    }
    
    sessionHandler.getData(from: urlObject, completion: completion)
  }
  
  // MARK: - POST
  
  func postAsync(
    to url: String,
    as requestType: RequestMethodType,
    _ data: Any?,
    _ params: Parser.JsonDictionary?,
    _ completion: @escaping (Any, ServerResponse) -> Void) {
    
    let request = sessionHandler.buildRequest(for: .http, buildEndpoint(url), requestType, params, data)
    
    sessionHandler.startSessionTask(with: request, completion: completion)
  }
  
  func uploadImage(_ data: Data, _ info: Parser.JsonDictionary, _ completion: @escaping (Any, ServerResponse) -> Void) {
    let url = buildEndpoint(Endpoints.updatePhoto.rawValue)
    
    let params = info.merging(RequestManager.sessionToken.asParams(), uniquingKeysWith: {
      first, second in
      return first
    })
    
    let request = sessionHandler.buildRequest(for: .multipart, url, .post, params, data)
    
    sessionHandler.startSessionTask(with: request, completion: completion)
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
    
    postAsync(to: url, as: .post, data, nil) { [weak self] tokenJson, response in
      if let _ = response.error {
        completion(nil, response)
        return
      }
      
      if !self!.rememberToken(from: tokenJson) {
        completion(nil, ServerResponse(ResponseStatus.cannotProceed.rawValue))
        return
      }
      
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
  
  private func rememberToken(from json: Any) -> Bool {
    guard let token = Parser.anyToObject(destination: Token.self, json) else {
      return false
    }
    
    guard let expires = token.expires else {
      return false
    }
    
    let expireDate = DateManager.shared.getExpirationDate(expires: expires)
    UserDefaults.standard.set(token.token, forKey: UserDefaultsKeys.sessionToken.rawValue)
    UserDefaults.standard.set(expireDate, forKey: UserDefaultsKeys.sessionExpires.rawValue)
//    print(token.token)
    RequestManager.sessionToken = token
    
    return true
  }
}
