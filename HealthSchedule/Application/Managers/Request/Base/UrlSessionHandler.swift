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
  
  func startSessionTask(
    _ url: String,
    _ type: RequestType = .get,
    body: Parser.JsonDictionary? = nil,
    params: Parser.JsonDictionary? = nil,
    completion: @escaping (Any, ServerResponse) -> Void) {
    
    guard let urlRequest = buildUrlRequest(url, type.rawValue, params, body) else {
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
  
  func getData(from url: URL, completion: @escaping (Data?) -> ()) {
    defaultSession.dataTask(with: url) {
      (data, response, error) in
      if error != nil {
        completion(nil)
        return
      }
      
      guard let objectData = data else {
        completion(nil)
        return
      }
      
      completion(objectData)
    }.resume()
  }
}

// MARK: - HELPERS

private extension UrlSessionHandler {
  private func buildUrlRequest(
    _ url: String,
    _ method: String,
    _ params: Parser.JsonDictionary?,
    _ body: Parser.JsonDictionary? = nil) -> URLRequest? {
    
    var parameterString = ""
    
    if let parameters = params {
      parameterString = parameters.asParamsString()
    }
    
    guard let url = URL(string: url + parameterString) else {
      print("Error: cannot create URL")
      return nil
    }
    
    var request = URLRequest(url: url)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = method
    
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
    
    guard let data = body?.asDataString().data(using: .ascii) else {
      return request
    }
    
    request.httpBody = data
    
    return request
  }
  
  static private func debugResponse(_ jsonData: Data) {
    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
      print(JSONString)
    }
  }
}
