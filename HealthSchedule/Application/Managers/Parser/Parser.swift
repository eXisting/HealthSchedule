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
  typealias JsonArrayDictionary = [String: [Dictionary<String, Any>]]

  class func anyArrayToObjectArray<DestinationType: Decodable>(destination: DestinationType.Type, _ data: Any) -> [DestinationType] {
    var result = [DestinationType]()
    
    guard let elementsList = data as? [Any] else {
      print("Cannot cast to [Any] in anyToObjectArray")
      print(data)
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
  
  class func processGeneralUserData(_ userData: Parser.JsonDictionary) -> Parser.JsonDictionary {
    var processedData = userData
    if let fullName = userData["fullName"] {
      var fullNameArr = fullName.components(separatedBy: " ")
      processedData.removeValue(forKey: "fullName")
      processedData["first_name"] = fullNameArr[0]
      processedData["last_name"] = fullNameArr[1]
    }
    
    processedData["phone"] = processedData["phone"]?.filter("01234567890.".contains)
    return processedData
  }
}
