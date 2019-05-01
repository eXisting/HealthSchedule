//
//  ImagesRequestHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class UrlSessionHandler {
  enum RequestType {
    case multipart
    case http
  }
  
  private let defaultSession = URLSession(configuration: .default)
  private let emptyJson: Parser.JsonDictionary = [:]
    
  func startSessionTask(
    with request: URLRequest?,
    completion: @escaping (Any, ServerResponse) -> Void
  ) {
    guard let urlRequest = request else {
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
  
  func buildRequest(
    for type: RequestType,
    _ url: String,
    _ method: RequestMethodType,
    _ params: Parser.JsonDictionary? = nil,
    _ body: Any? = nil
  ) -> URLRequest? {
    switch type {
    case .multipart:
      return multipartUploadRequest(url, method, params, body as! Data)
    case .http:
      return httpRequest(url, method, params, body)
    }
  }
}

// MARK: - HELPERS

private extension UrlSessionHandler {
  private func httpRequest(
    _ url: String,
    _ method: RequestMethodType,
    _ params: Parser.JsonDictionary?,
    _ body: Any? = nil
  ) -> URLRequest? {
    
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
    request.httpMethod = method.rawValue
    
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
  
  private func multipartUploadRequest(
    _ url: String,
    _ method: RequestMethodType = .post,
    _ params: Parser.JsonDictionary?,
    _ data: Data
  ) -> URLRequest? {
    
    guard let params = params else {
      print("params in multipart request is nil")
      return nil
    }
    
    guard let filename = params[ProfileImageJsonFields.filename.rawValue],
      let mimeType = params[ProfileImageJsonFields.mimeType.rawValue],
      let token = params[TokenJsonFields.token.rawValue] else {
      print("Some params are not passed")
      return nil
    }
    
    //?token=1234 insertion to the end of url
    let parameterString = [TokenJsonFields.token.rawValue: token].asParamsString()
    guard let url = URL(string: url + parameterString) else {
      print("Error: cannot create URL")
      return nil
    }
    
    let boundary = "Boundary-\(UUID().uuidString)"
    let boundaryPrefix = "--\(boundary)\r\n"
    
    var request = URLRequest(url: url)
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let body = NSMutableData()
    
    body.appendString(boundaryPrefix)
    body.appendString("Content-Disposition: form-data; name=\"_method\"\r\n\r\n")
    body.appendString("PUT\r\n")
    
    body.appendString(boundaryPrefix)
    body.appendString("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimeType)\r\n\r\n")
    body.append(data)
    body.appendString("\r\n")
    body.appendString("--".appending(boundary.appending("--")))
    
    request.httpMethod = method.rawValue
    request.httpBody = body as Data
    
    return request
  }
  
  static private func debugResponse(_ jsonData: Data) {
    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
      print(JSONString)
    }
  }
}

// Extension for possibility to append string into multipart upload
extension NSMutableData {
  func appendString(_ string: String) {
    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
    append(data!)
  }
}
