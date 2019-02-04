//
//  ImagesRequestHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestHandler {
  
  typealias PostCompletion = ((Data, Error?) -> Void)
  typealias Usercompletion = (((User, UserMessage?, Error?)) -> Void)

  static let shared = RequestHandler()
  
  private let defaultSession = URLSession(configuration: .default)
  
  private init() {}
  
  private func getJsonAsync(from url: String, _ params: Parser.JsonDictionary?, completion: @escaping (Any) -> Void) {
    guard let urlRequest = buildUrlRequest(url, params, RequestType.get.rawValue) else {
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
  
  private func postDataAsync(to url: String, type: RequestType, params: Parser.JsonDictionary?, body: Data, completion: @escaping PostCompletion) {
    // TODO: Return error in tuple    
    guard var urlRequest = buildUrlRequest(url, params, type.rawValue) else {
      return
    }
    
    urlRequest.httpBody = body
    
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
  func getToken(from url: String, body: Data, completion: @escaping PostCompletion) {
    postDataAsync(to: url, type: .post, params: nil, body: body, completion: completion)
  }
}

extension RequestHandler: Requesting {
  func postAsync(to url: String, as type: RequestType, _ body: Data, _ params: Parser.JsonDictionary?, completion: @escaping PostCompletion) {
    postDataAsync(to: url, type: type, params: params, body: body, completion: completion)
  }
  
  func getAsync(from url: String, _ params: Parser.JsonDictionary?, completion: @escaping (Any) -> Void) {
    getJsonAsync(from: url, params, completion: completion)
  }
}

// MARK: - HELPERS

private extension RequestHandler {
  func buildUrlRequest(_ url: String, _ params: Parser.JsonDictionary?, _ method: String) -> URLRequest? {
    var parameterString = ""
    
    if let parameters = params {
      parameterString = parameters.asParamsString()
    }
    
    guard let url = URL(string: url + parameterString) else {
      print("Error: cannot create URL")
      return nil
    }
    
    var request = URLRequest(url: url)
    
    request.allHTTPHeaderFields = ["Content-Type": "application/json"]
    request.httpMethod = method
    
    return request
  }
  
  static func debugResponse(_ jsonData: Data) {
    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
      print(JSONString)
    }
  }
}
