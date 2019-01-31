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

enum RequestError: Error {
  case EndPointError(reason: String)
  case SerializationError(reason: String)
}

class RequestHandler {
  
  typealias PostComplition = (((Any, Error?)) -> Void)
  typealias JsonDictionary = [String:String]
  typealias BodyDictionary = [String:Any]

  static let shared = RequestHandler()
  
  private let defaultSession = URLSession(configuration: .default)
  
  private init() {}
  
  private func fetchAsync(from url: String, _ params: JsonDictionary?, completion: @escaping ([Any]) -> Void) {
    
    guard let urlRequest = buildUrlRequest(url, params, "GET") else {
      return
    }
    
    let task = defaultSession.dataTask(with: urlRequest) {
      (recivedData, serverResponse, error) in
      
      guard error == nil else {
        print(error!)
        return
      }
      
      guard let jsonData = recivedData else {
        print("Error: did not receive data")
        return
      }
      
      do {
        //RequestHandler.debugResponse(jsonData)
        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if let jsonArray = json as? [Any] {
          completion(jsonArray)
          return
        }
        completion([json])
      } catch  {
        print("error trying to convert data to JSON")
        return
      }
    }
    
    task.resume()
  }
  
  private func fetchObjectAsync(from url: String, _ params: JsonDictionary?, completion: @escaping (Any) -> Void) {
    fetchAsync(from: url, params) { response in
      if response.count == 0 {
        print("Nothing has returned!")
        return
      }
      
      completion(response[0])
    }
  }
  
  private func postAsync(to url: String, params: JsonDictionary?, bodyData: BodyDictionary, completion: @escaping PostComplition) {
    // TODO: Return error in tuple
    
    guard var urlRequest = buildUrlRequest(url, params, "POST") else {
      return
    }
    
    do {
      let data = try JSONSerialization.data(withJSONObject: bodyData)
      urlRequest.httpBody = data
    } catch {
      print("Cannot either serialize or encode body data")
    }
    
   let task = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        return
      }
    
      guard let jsonData = data else {
        print("no readable data received in response")
        return
      }
    
      do {
        //RequestHandler.debugResponse(jsonData)
        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        let result: (Any, Error?) = (json, nil)
        completion(result)
      } catch  {
        print("error trying to convert data to JSON")
        return
      }
    }
    
    task.resume()
  } 
}

extension RequestHandler: GetRequesting {
  func getObjectAsync(from url: String, _ params: JsonDictionary?, complition: @escaping (Any) -> Void) {
    fetchObjectAsync(from: url, params, completion: complition)
  }
  
  func getAsync(from url: String, _ params: JsonDictionary?, complition: @escaping ([Any]) -> Void) {
    fetchAsync(from: url, params, completion: complition)
  }
}

extension RequestHandler: AuthProviding {
  func fetchToken(from url: String, bodyData: BodyDictionary, completion: @escaping RequestHandler.PostComplition) {
    postAsync(to: url, params: nil, bodyData: bodyData, completion: completion)
  }
}


// Helpers
private extension RequestHandler {
  private func buildUrlRequest(_ url: String, _ params: JsonDictionary?, _ method: String) -> URLRequest? {
    var parameterString = ""
    
    if let parameters = params {
      parameterString = parameters.asParamsString()
    }
    
    guard let url = URL(string: url + parameterString) else {
      print("Error: cannot create URL")
      return nil
    }
    
    var request = URLRequest(url: url)
    
    var headers: JsonDictionary = [:]
    headers["Content-Type"] = "application/json"
    
    request.allHTTPHeaderFields = headers
    request.httpMethod = method
    
    return request
  }
  
  private static func debugResponse(_ jsonData: Data) {
    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
      print(JSONString)
    }
  }
}

extension String {
  
  /// Percent escapes values to be added to a URL query as specified in RFC 3986
  ///
  /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
  ///
  /// http://www.ietf.org/rfc/rfc3986.txt
  ///
  /// - returns: Returns percent-escaped string.
  
  func addingPercentEncodingForURLQueryValue() -> String? {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    
    var allowed = CharacterSet.urlQueryAllowed
    allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
    
    return addingPercentEncoding(withAllowedCharacters: allowed)
  }
  
}

extension Dictionary where Key == String, Value == String {
  
  // Shortcut for parsing dictionary as params string
  
  func asParamsString() -> String {
    let parameterArray = map { key, value -> String in
      let percentEscapedKey = key.addingPercentEncodingForURLQueryValue()!
      let percentEscapedValue = value.addingPercentEncodingForURLQueryValue()!
      return "\(percentEscapedKey)=\(percentEscapedValue)"
    }
    
    return "?" + parameterArray.joined(separator: "&")
  }
}
