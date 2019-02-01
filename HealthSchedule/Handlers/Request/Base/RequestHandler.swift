//
//  ImagesRequestHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum Endpoints: String {
  // GET
  case user = "/api/user"
  case provider = "/api/provider"
  case allCities = "/api/cities"
  case allProfessions = "/api/category/doctors/professions"
  
  // POST
  case signUpAsUser = "/api/register/user"
  case signUpAsProvider = "/api/register/provider"
  
  case signIn = "/api/login"
}

class RequestHandler {
  
  typealias PostComplition = (((Data, Error?)) -> Void)
  typealias UserComplition = (((User, UserMessage?, Error?)) -> Void)

  static let shared = RequestHandler()
  
  private let defaultSession = URLSession(configuration: .default)
  
  private init() {}
  
  private func getJsonAsync(from url: String, _ params: Serializer.JsonDictionary?, completion: @escaping (Any) -> Void) {
    guard let urlRequest = buildUrlRequest(url, params, "GET") else {
      return
    }
    
    let task = defaultSession.dataTask(with: urlRequest) {
      (data, response, error) in
      
      guard error == nil else {
        print(error!)
        return
      }
      
      guard let jsonData = data else {
        print("Error: did not receive data")
        return
      }
      
      guard let json = Serializer.encodeWithJsonSerializer(data: jsonData) else {
        return
      }
      
      completion(json)
    }
    
    task.resume()
  }
  
  private func postAsync(to url: String, params: Serializer.JsonDictionary?, bodyData: Serializer.BodyDictionary, completion: @escaping (Data, Error?) -> Void) {
    // TODO: Return error in tuple    
    guard var urlRequest = buildUrlRequest(url, params, "POST") else {
      return
    }
    
    urlRequest.httpBody = Serializer.getDataFrom(object: bodyData)
    
    let task = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        return
      }
    
      guard let jsonData = data else {
        print("no readable data received in response")
        return
      }
    
      completion(jsonData, nil)
    }
    
    task.resume()
  } 
}

// MARK: - EXTENSIONS

extension RequestHandler: AuthProviding {
  func getToken(from url: String, bodyData: Serializer.BodyDictionary, completion: @escaping PostComplition) {
    postAsync(to: url, params: nil, bodyData: bodyData, completion: completion)
  }
}

extension RequestHandler: GetRequesting {
  func getObjectAsync(from url: String, _ params: Serializer.JsonDictionary?, complition: @escaping (Any) -> Void) {
    getJsonAsync(from: url, params, completion: complition)
  }
  
  func getAsync(from url: String, _ params: Serializer.JsonDictionary?, complition: @escaping ([Any]) -> Void) {
    getJsonAsync(from: url, params) { data in
      complition([data])
    }
  }
}

// MARK: - HELPERS

private extension RequestHandler {
  func buildUrlRequest(_ url: String, _ params: Serializer.JsonDictionary?, _ method: String) -> URLRequest? {
    var parameterString = ""
    
    if let parameters = params {
      parameterString = parameters.asParamsString()
    }
    
    guard let url = URL(string: url + parameterString) else {
      print("Error: cannot create URL")
      return nil
    }
    
    var request = URLRequest(url: url)
    
    var headers: Serializer.JsonDictionary = [:]
    headers["Content-Type"] = "application/json"
    
    request.allHTTPHeaderFields = headers
    request.httpMethod = method
    
    return request
  }
  
  static func debugResponse(_ jsonData: Data) {
    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
      print(JSONString)
    }
  }
}
