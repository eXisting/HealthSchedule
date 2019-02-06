//
//  Parser.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class Parser {
  typealias JsonDictionary = [String:String]
  
  class func anyArrayToObjectArray<DestinationType: Decodable>(destination: DestinationType.Type, _ data: Any) -> [DestinationType] {
    var result = [DestinationType]()
    
    guard let elementsList = data as? [Any] else {
      print("Cannot cast to [Any] in anyToObjectArray")
      return []
    }
    
    for element in elementsList {
      guard let destinationObject = anyToObject(destination: DestinationType.self, element) else {
        continue
      }
      
      result.append(destinationObject)
    }
    
    return result
  }
  
  class func anyToObject<DestinationType: Decodable>(destination: DestinationType.Type, _ object: Any) -> DestinationType? {
    guard let data = Serializer.getDataFrom(json: object) else {
      return nil
    }
    
    guard let result = Serializer.decodeDataInto(type: DestinationType.self, data) else {
      return nil
    }
    
    return result
  }
}
