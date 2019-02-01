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
  
  private static let getRequest: GetRequesting = RequestHandler.shared
  private static let authRequests: AuthProviding = RequestHandler.shared
  
  private static var sessionToken: String?
  
  class func getListAsyncFor<T: JsonInitiableModel>(type: T.Type, from endpoint: Endpoints, _ headers: Serializer.JsonDictionary?, _ complition: @escaping ([T]) -> Void) {
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
  
  class func getAsyncFor<T: JsonInitiableModel>(type: T.Type, from endpoint: Endpoints, _ params: Serializer.JsonDictionary?, _ complition: @escaping (T) -> Void) {
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
  
  class func signIn(authType: UserType, body: Serializer.JsonDictionary, _ complition: @escaping RequestHandler.UserComplition) {
    authRequests.getToken(from: buildEndpoint(Endpoints.signIn.rawValue), bodyData: body) { (data, error) in
      let endpoint = authType == .client ? Endpoints.user : Endpoints.provider
      
      getAsyncFor(type: User.self, from: endpoint, [TokenJsonFields.token.rawValue: rememberTokenFrom(data)]) { user in
        complition((user, nil, nil))
      }
    }
  }
  
  class func signUp(authType: UserType, body: Serializer.BodyDictionary, _ complition: @escaping RequestHandler.UserComplition) {
    let isClientSignUp = authType == .client
    
    let endpoint = isClientSignUp ? Endpoints.signUpAsUser : Endpoints.signUpAsProvider
    
    authRequests.getToken(from: buildEndpoint(endpoint.rawValue), bodyData: body) { (data, error) in
      getAsyncFor(type: User.self, from: .user, [TokenJsonFields.token.rawValue: rememberTokenFrom(data)]) { user in
        complition((user, !isClientSignUp ? .accountModeration : nil, nil))
      }
    }
  }
}

extension RequestManager {
  private class func buildEndpoint(_ route: String) -> String {
    return rootEndpoint + route
  }
  
  private class func rememberTokenFrom(_ data: Data) -> String {
    guard let token = Serializer.decodeDataInto(type: Token.self, data) else {
      return ""
    }
    
    guard let tokenValue = token.token else {
      print("No token found!")
      return ""
    }
    
    sessionToken = tokenValue
    
    return tokenValue
  }
}
