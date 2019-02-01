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
  case addressId = "address_id"
  case image = "image"
  
  case role = "user_role_id"
}

enum UserType: Int {
  case provider = 1
  case client = 2
}

struct User {
  // CONSIDER USE DIFFERENT APPROACH
  struct Provider {
    var professions: [ProviderProfession]
    var certificates: [ProfileImage]
    var services: [ProviderService]
    
    var scheduleTemplate: [ScheduleWeekDay]
    var scheduleExceptions: [ScheduleDateException]
    
    init?(json: [String: Any]) {
      // TODO: Init
      professions = []
      certificates = []
      services = []
      scheduleTemplate = []
      scheduleExceptions = []
    }
  }
  
  var id: Int
  var firstName: String
  var lastName: String
  var email: String
  var phone: String
  var status: Bool
  var birthday: Any
  
  var userType: UserType = .client
  
  var providerData: Provider?
  var photo: ProfileImage?
}

extension User: JsonInitiableModel {
  init?(json: [String: Any]) {
    guard let id = json[UserJsonFields.id.rawValue] as? Int,
      let firstName = json[UserJsonFields.firstName.rawValue] as? String,
      let lastName = json[UserJsonFields.lastName.rawValue] as? String,
      let email = json[UserJsonFields.email.rawValue] as? String,
      let phone = json[UserJsonFields.phone.rawValue] as? String,
      let status = json[UserJsonFields.status.rawValue] as? Bool,
      let birthday = json[UserJsonFields.birthday.rawValue],
      let role = json[UserJsonFields.role.rawValue] as? Int else {
        print("Cannot parse json fields in User.init!")
        return nil
    }
    
    if let userImageObjectJson = json[UserJsonFields.image.rawValue] as? [String:Any] {
      // PHOTO
    }
    
    self.id = id
    self.firstName = firstName.capitalized
    self.lastName = lastName.capitalized
    self.email = email
    self.phone = phone
    self.status = status
    self.birthday = birthday
    
    userType = UserType(rawValue: role) ?? .client
    
    if userType == .provider {
      // TODO: Fill provider data
      providerData = Provider(json: json)
    }
  }
}
