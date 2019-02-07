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
    return try? decoder.decode(type, from: data)
  }
  
  class func encodeDataFrom<T: Encodable>(object: T) -> Data? {
    return try? encoder.encode(object)
  }
  
  class func getDataFrom(json: Any) -> Data? {
    return try? JSONSerialization.data(withJSONObject: json)
  }
  
  class func encodeWithJsonSerializer(data: Data) -> Any? {
    return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  }
}

