//
//  Parser.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum UserMessage: String {
  case accountModeration = "Your account is under moderation!"
}

class ModelSerializer {
  class func decodeDataInto<T: Decodable>(type: T.Type, _ data: Data) -> T {
    var result: T!
    
    do {
      result = try JSONDecoder().decode(type, from: data)
    }
    catch {
      print("DecodeDataInto throws error!")
    }
    
    return result
  }
  
  class func encodeData<T: Decodable>(type: T.Type) -> 
}
