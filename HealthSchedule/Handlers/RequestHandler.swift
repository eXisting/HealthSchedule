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
  
}

extension RequestHandler: RateableRequesting {
  func postRate(for url: String, withRate rate: Int) {
    // TODO
  }
  
  func getRate(from url: String) -> Int {
    // TODO
    return 0
  }
}

extension RequestHandler: ImageRequesting {
  func postImage(for url: String, withImage image: UIImage) {
    // TODO
  }
  
  func getImage(from url: String) -> UIImage? {
    let endpointUrl = URL(string: url)
    let data = try? Data(contentsOf: endpointUrl!)
    
    return UIImage(data: data!)
  }
}
