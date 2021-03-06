//
//  ImagesRequestHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class UrlSessionHandler {
  
  private let defaultSession = URLSession(configuration: .default)
  private let emptyJson: Parser.JsonDictionary = [:]
    
  func startSessionTask(
    _ url: String,
    _ type: RequestType = .get,
    body: Any? = nil,
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
        completion(self!.emptyJson, ServerResponse(ResponseStatus.serverError.rawValue))
        return
      }
      
      // TODO: only 14 requests parsed from json but response is full - 23
      
      guard let serverError = Parser.anyToObject(destination: ServerResponse.self, json) else {
        // if object has been casted - return without exception
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
    _ body: Any? = nil) -> URLRequest? {
    
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
    
    if let jsonDictBody = body as? Parser.JsonDictionary {
      guard let data = jsonDictBody.asDataString().data(using: .ascii) else {
        return request
      }
      
      request.httpBody = data
    } else {
      // application/json; charset=utf-8 fixs problem with array serialization
      request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.httpBody = (body as? Data)
    }
    
    return request
  }
  
  static private func debugResponse(_ jsonData: Data) {
    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
      print(JSONString)
    }
  }
}
