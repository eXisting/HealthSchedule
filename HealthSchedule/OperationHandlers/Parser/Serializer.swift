//
//  ModelSerializer.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum UserMessage: String {
  case accountModeration = "Your account is under moderation!"
}

class Serializer {
  
  private static let decoder = JSONDecoder()
  private static let encoder = JSONEncoder()
  
  class func decodeDataInto<T: Decodable>(type: T.Type, _ data: Data) -> T? {
    var result: T?
    
    do {
      result = try decoder.decode(type, from: data)
    }
    catch {
      print("DecodeDataInto throws error!")
    }
    
    return result
  }
  
  class func encodeDataFrom<T: Encodable>(object: T) -> Data? {
    var result: Data?
    
    do {
      result = try encoder.encode(object)
    }
    catch {
      print("encodeDataFrom throws error!")
    }
    
    return result
  }
  
  class func getDataFrom(json: Any) -> Data? {
    var result: Data?
    
    do {
      result = try JSONSerialization.data(withJSONObject: json)
    } catch {
      print("Cannot either serialize or encode body data")
    }
    
    return result
  }
  
  class func encodeWithJsonSerializer(data: Data) -> Any? {
    var result: Any?
    
    do {
      result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    } catch {
      print("Cannot either serialize or encode body data")
    }
    
    return result
  }
}

