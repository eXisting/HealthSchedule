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
  
  class func processAvailableTimes(_ json: Any) -> RemoteAvailableTimeContainer.AvailableDatesSortedArray {
    guard let dict = json as? [String: Any] else {
      return []
    }
    
    var parsedArray: RemoteAvailableTimeContainer.AvailableDatesSortedArray = []
    
    for element in dict {
      guard let elementValues = element.value as? [String: Any] else {
        return []
      }
      
      guard let date = elementValues[AvailableTimeJson.date.rawValue] as? String else {
        return []
      }
      
      guard let timesForDate = elementValues[AvailableTimeJson.times.rawValue] as? [String: [Int]] else {
        return []
      }
      
      var timesArray: RemoteAvailableTimeContainer.AvailableTimesSortedArray = []
      for timeElement in timesForDate {
        let timeValue = DateManager.shared.stringToDate(timeElement.key, format: .fullTime, .hour24)
        
        if var existingArray = timesArray.first(where: {$0.0 == timeValue} ) {
          existingArray.1.append(contentsOf: timeElement.value)
        } else {
          timesArray.append((timeValue, timeElement.value))
        }
      }
      
      let dateValue = DateManager.shared.stringToDate(date, format: .date, .posix)
      parsedArray.append((dateValue, timesArray.sorted(by: { $0.0 < $1.0 } )))
    }
    
    return parsedArray.sorted(by: { $0.0 < $1.0 } )
  }
}
