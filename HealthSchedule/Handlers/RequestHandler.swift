//
//  ImagesRequestHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestHandler {
  
  static let shared = RequestHandler()
  
  private let defaultSession = URLSession(configuration: .default)

  private var dataTask: URLSessionDataTask?
  
  private func fetch(from url: String, with query: String?, completion: @escaping () -> Void) -> [Any] {
    
    //create the url with NSURL
    let dataURL = URL(string: url)! //change the url
    
    dataTask?.cancel()
    
    if var urlComponents = URLComponents(string: url) {
      urlComponents.query = query ?? ""
      
      guard let url = urlComponents.url else { return [] }
      
      dataTask = defaultSession.dataTask(with: url) { data, response, error in
        defer { self.dataTask = nil }
        
        if let error = error {
          //self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200 {
          //self.updateSearchResults(data)
          
          DispatchQueue.main.async {
            //completion(self.tracks, self.errorMessage)
          }
        }
      }
      
      dataTask?.resume()
    }
      
    return []
  }
}

extension RequestHandler: RateableRequesting {
  func postRate(for url: String, with rate: Int) {
    // TODO
  }
  
  func getRate(from url: String) -> Int {
    // TODO
    return 0
  }
}

extension RequestHandler: ImageRequesting {
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
  
  func get(from url: String, complition: @escaping () -> Void) -> [Any] {
    let result = fetch(from: url, with: nil, completion: complition)
    
    return result
  }
  
  func get(from url: String, with query: String, complition: @escaping () -> Void) -> [Any] {
    let result = fetch(from: url, with: query, completion: complition)
    
    return []
  }
  
  
  
  
}
