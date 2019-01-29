//
//  ImagesRequestHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum RequestError: Error {
  case EndPointError(reason: String)
  case SerializationError(reason: String)
}

class RequestHandler {
  
  typealias PostComplition = (((Any, Error?)) -> Void)
  typealias JsonDictionary = [String:String]

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
  
  func postAsync(to url: String, params: JsonDictionary?, bodyData: JsonDictionary, completion: @escaping PostComplition) {
    // TODO: Return error in tuple
    
    guard var urlRequest = buildUrlRequest(url, params, "POST") else {
      return
    }
    
    let encoder = JSONEncoder()
    do {
      let jsonData = try encoder.encode(bodyData)
      urlRequest.httpBody = jsonData
      
      print("jsonData: ", String(data: urlRequest.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
      print("Cannot encode data")
    }
    
   let task = defaultSession.dataTask(with: urlRequest) { (responseData, response, responseError) in
      guard responseError == nil else {
        return
      }
    
      guard let jsonData = responseData else {
        print("no readable data received in response")
        return
      }
    
      do {
        //debugResponse(jsonData)
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

extension RequestHandler: ImageRequesting {
  func getImageAsync(from url: String, for index: Int?, completion: @escaping (Int?, UIImage?) -> Void) {
    
    guard let url = URL(string: url) else {
      print("Error: cannot create URL")
      return
    }
    let urlRequest = URLRequest(url: url)
    
    let task = defaultSession.dataTask(with: urlRequest) {
      (data, response, error) in
      
      guard error == nil else {
        print(error!)
        return
      }
      
      guard let responseData = data else {
        print("Error: did not receive data")
        return
      }
      
      completion(index, UIImage(data: responseData))
    }
    
    task.resume()
  }
  
  func postImage(for url: String, with image: UIImage) {
    // TODO
  }
  
  func getImage(from url: String) -> UIImage? {
    let endpointUrl = URL(string: url)
    let data = try? Data(contentsOf: endpointUrl!)
    
    return UIImage(data: data!)
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
  func login(to url: String, params: JsonDictionary?, bodyData: JsonDictionary, completion: @escaping RequestHandler.PostComplition) {
    postAsync(to: url, params: params, bodyData: bodyData, completion: completion)
  }
  
  func singUp() {
    // TODO
  }
  
  func singIn() {
    // TODO
  }
}


// Helpers
extension RequestHandler {
  private func buildUrlRequest(_ url: String, _ params: JsonDictionary?, _ method: String) -> URLRequest? {
    
    var parameterString = ""
    if let parameters = params {
      let parameterArray = parameters.map { key, value -> String in
        let percentEscapedKey = key.addingPercentEncodingForURLQueryValue()!
        let percentEscapedValue = value.addingPercentEncodingForURLQueryValue()!
        return "\(percentEscapedKey)=\(percentEscapedValue)"
      }
      
      parameterString = "?" + parameterArray.joined(separator: "&")
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
