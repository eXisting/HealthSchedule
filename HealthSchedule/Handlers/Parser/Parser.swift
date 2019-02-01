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
  typealias BodyDictionary = [String:Any]
  
  class func anyArrayToObjectArray<DestinationType: Decodable>(destination: DestinationType.Type, _ data: Any) -> [DestinationType] {
    var result = [DestinationType]()
    
    guard let elementsList = data as? [Any] else {
      print("Cannot cast to [Any] in anyToObjectArray")
      return []
    }
    
    for element in elementsList {
      
      guard let elementData = Serializer.getDataFrom(object: element) else {
        continue
      }
      
      guard let destinationObject = Serializer.decodeDataInto(type: DestinationType.self, elementData) else {
        print("Cannot cast to [String:Any] in anyToObjectArray")
        continue
      }
      
      result.append(destinationObject)
    }
    
    return result
  }
}
