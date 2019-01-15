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
  
  static let shared = RequestHandler()
  
  private let defaultSession = URLSession(configuration: .default)
  private var dataTask: URLSessionDataTask?
  
  private func fetchAsync(from url: String, with query: String?, completion: @escaping ([Any]) -> Void) {
    
    guard let url = URL(string: url) else {
      print("Error: cannot create URL")
      return
    }
    let urlRequest = URLRequest(url: url)
  
    // make the request
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
      
      do {
        guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
          as? [String: Any] else {
            print("error trying to convert data to JSON")
            return
        }
        
        //print(todo["results"] ?? "nothing")
        let result = todo["results"] as! [Any]
        
        completion(result)
      } catch  {
        print("error trying to convert data to JSON")
        return
      }
    }
    
    task.resume()
  }
  
  class func buildEndPointUrl() -> String {
    
    var url = "https://randomuser.me/api"
    
    url.append("/?results=")
    url.append("20")
    url.append("&format=")
    url.append("json")
    
    return url
  }
  
}

extension RequestHandler: ImageRequesting {
  func getImageAsync(from url: String, completion: @escaping (UIImage?) -> Void) {
    
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
      
      completion(UIImage(data: responseData))
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

extension RequestHandler: ListsRequesting {
  
  func getAsync(from url: String, complition: @escaping ([Any]) -> Void) {
    fetchAsync(from: url, with: nil, completion: complition)    
  }
  
  func getAsync(from url: String, with query: String, complition: @escaping ([Any]) -> Void) {
    // TODO
  }
  
  
  
  
}
