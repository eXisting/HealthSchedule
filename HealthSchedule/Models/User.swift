//
//  User.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/29/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum UserJsonFields: String {
  case id = "id"
  case firstName = "first_name"
  case lastName = "last_name"
  case email = "email"
  case phone = "phone"
  case status = "confirmed_status"
  case birthday = "birthday_at"
  case image = "image"
}

enum UserType: Int {
  case provider = 1
  case client = 2
}

struct User {
  var id: Int
  var firstName: String
  var lastName: String
  var email: String
  var phone: String
  var status: Bool
  var birthday: Any
  
  
  var photo: RemoteImage?
  var userType: UserType = .client
}

extension User: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[UserJsonFields.id.rawValue] as? Int,
      let firstName = json[UserJsonFields.firstName.rawValue] as? String,
      let lastName = json[UserJsonFields.lastName.rawValue] as? String,
      let email = json[UserJsonFields.email.rawValue] as? String,
      let phone = json[UserJsonFields.phone.rawValue] as? String,
      let status = json[UserJsonFields.status.rawValue] as? Bool,
      let birthday = json[UserJsonFields.birthday.rawValue] else {
        print("Cannot parse json fields in User.init!")
        return nil
    }
    
    if let userImageObjectJson = json[UserJsonFields.image.rawValue] as? [String:Any] {
      photo = RemoteImage(json: userImageObjectJson)
    }
    
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.phone = phone
    self.status = status
    self.birthday = birthday
  }
}
