//
//  User.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/29/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum UserJsonFields: String, CodingKey {
  case id
  case image
  case phone
  case email
  
  case firstName = "first_name"
  case lastName = "last_name"
  case status = "confirmed_status"
  case birthday = "birthday_at"
  case addressId = "address_id"
  case role = "user_role_id"
}

enum UserType: Int, Codable {
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
  var birthday: Date
  
  var userType: UserType = .client
  
//  var providerData: Provider?
//  var photo: ProfileImage?
}

extension User: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: UserJsonFields.self)
    try container.encode(id, forKey: .id)
    try container.encode(firstName, forKey: .firstName)
    try container.encode(lastName, forKey: .lastName)
    try container.encode(email, forKey: .email)
    try container.encode(phone, forKey: .phone)
    try container.encode(status, forKey: .status)
    try container.encode(birthday, forKey: .birthday)
    try container.encode(userType, forKey: .role)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    firstName = try container.decode(String.self, forKey: .firstName)
    lastName = try container.decode(String.self, forKey: .lastName)
    email = try container.decode(String.self, forKey: .email)
    phone = try container.decode(String.self, forKey: .phone)
    status = try container.decode(Bool.self, forKey: .status)
    
    let birthdayString = try container.decode(String.self, forKey: .birthday)
    birthday = DatesManager.shared.createDateFrom(birthdayString)
    
    let role = try container.decode(Int.self, forKey: .role)    
    userType = UserType(rawValue: role) ?? .client
    if userType == .provider {
      // TODO: Fill provider data
      //providerData = Provider(json: json)
    }
  }
}
