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
  
  private func fetchAsync(from url: String, completion: @escaping ([Any]) -> Void) {
    
    guard let url = URL(string: url) else {
      print("Error: cannot create URL")
      return
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    
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
        //for debugging
//        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//          print(JSONString)
//        }
        
        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [Any]
        
        completion(json ?? [])
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

extension RequestHandler: ListsRequesting {
  func getAsync(from url: String, complition: @escaping ([Any]) -> Void) {
    fetchAsync(from: url, completion: complition)
  }
}
