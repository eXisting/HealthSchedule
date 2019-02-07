//
//  ImagesRequestHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class UrlSessionHandler {
  
  static let shared = UrlSessionHandler()
  
  private let defaultSession = URLSession(configuration: .default)
  private let emptyJson: Parser.JsonDictionary = [:]
  
  private init() {}
  
  func getAsync(from url: String, _ params: Parser.JsonDictionary?, completion: @escaping (Any, ServerResponse) -> Void) {
    guard let urlRequest = buildUrlRequest(url, params, RequestType.get.rawValue) else {
      completion(emptyJson, ServerResponse(ResponseStatus.cannotProceed.rawValue))
      return
    }
    
    let task = defaultSession.dataTask(with: urlRequest) { [weak self]
      (data, response, error) in
      
      if error != nil {
        completion(self!.emptyJson, ServerResponse(error?.localizedDescription))
        return
      }
      
      guard let jsonData = data else {
        completion(self!.emptyJson, ServerResponse(ResponseStatus.serverError.rawValue))
        return
      }
      
      guard let json = Serializer.encodeWithJsonSerializer(data: jsonData) else {
        completion(self!.emptyJson, ServerResponse(ResponseStatus.serverError.rawValue))
        return
      }
      
      guard let serverError = Parser.anyToObject(destination: ServerResponse.self, json) else {
        completion(json, ServerResponse())
        return
      }
      
      completion(serverError.error ?? json, serverError)
    }
    
    task.resume()
  }
  
  func postAsync(to url: String, type: RequestType, body: Data?, params: Parser.JsonDictionary?, completion: @escaping (Any, ServerResponse) -> Void) {
    guard var urlRequest = buildUrlRequest(url, params, type.rawValue) else {
      completion(emptyJson, ServerResponse(ResponseStatus.cannotProceed.rawValue))
      return
    }
    
    urlRequest.httpBody = body
    
    let task = defaultSession.dataTask(with: urlRequest) { [weak self]
      (data, response, error) in
      if error != nil {
        completion(self!.emptyJson, ServerResponse(error?.localizedDescription))
        return
      }
      
      guard let jsonData = data else {
        completion(self!.emptyJson, ServerResponse(ResponseStatus.serverError.rawValue))
        return
      }
    
      guard let json = Serializer.encodeWithJsonSerializer(data: jsonData) else {
        completion(self!.emptyJson,  ServerResponse(ResponseStatus.serverError.rawValue))
        return
      }
      
      guard let serverError = Parser.anyToObject(destination: ServerResponse.self, json) else {
        completion(json, ServerResponse())
        return
      }
      
      completion(serverError.error ?? json, serverError)
    }
    
    task.resume()
  } 
}

// MARK: - HELPERS

private extension UrlSessionHandler {
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
