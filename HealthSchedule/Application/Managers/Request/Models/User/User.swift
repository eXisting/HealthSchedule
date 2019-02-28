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
  case role
  case city
  case password
  
  case firstName = "first_name"
  case lastName = "last_name"
  case status = "confirmed_status"
  case birthday = "birthday_at"
  
  // Edit fields
  case cityId = "city_id"
}

// TODO: Get this on app launch
enum UserTypeName: String {
  case client = "Client"
  case provider = "Provider"
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
  var phone: String?
  var status: Bool
  var birthday: Date
  
  var role: Role
  var city: City?
  var photo: ProfileImage?
  
  var providerData: ProviderData?
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
    try container.encode(role, forKey: .role)
    try container.encode(city, forKey: .city)

    let birthdayString = DateManager.shared.dateToString(birthday)
    try container.encode(birthdayString, forKey: .birthday)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserJsonFields.self)
    id = try container.decode(Int.self, forKey: .id)
    firstName = try container.decode(String.self, forKey: .firstName)
    lastName = try container.decode(String.self, forKey: .lastName)
    email = try container.decode(String.self, forKey: .email)
    phone = try container.decode(String.self, forKey: .phone)
    status = try container.decode(Bool.self, forKey: .status)
    city = try? container.decode(City.self, forKey: .city)
    role = try container.decode(Role.self, forKey: .role)
    photo = try? container.decode(ProfileImage.self, forKey: .image)

    let birthdayString = try container.decode(String.self, forKey: .birthday)
    birthday = DateManager.shared.stringToDate(birthdayString)
    
    providerData = ProviderData()
  }
}
