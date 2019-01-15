//
//  ExpertProfile.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ProfileValidationError: Error {
  case nameError
  case surnameError
  case phoneError
  case emailError
  case imageUrlError
}

enum ProfileJsonFields: String {
  case firstName = "first"
  case lastName = "last"
  case location = "location"
  case state = "state"
//  case email = "email"
//  case phone = "phone"
  case picture = "picture"
  case large = "large"
  case thumbnail = "thumbnail"
}

struct ExpertProfile {
  var firstName: String
  var lastName: String
  var location: String
  
  var pictureUrls: [String: Any]?
  var profilePhoto: UIImage?
}

extension ExpertProfile {
  init?(json: [String: Any]) {
    guard let nameContainer = json["name"] as? [String:String],
      let locationContainer = json[ProfileJsonFields.location.rawValue] as? [String: Any],
      let picturesContainer = json[ProfileJsonFields.picture.rawValue] as? [String: Any],
      let firstName = nameContainer[ProfileJsonFields.firstName.rawValue],
      let lastName = nameContainer[ProfileJsonFields.lastName.rawValue],
      let state = locationContainer[ProfileJsonFields.state.rawValue] as? String
      else {
        return nil
    }
    
    self.firstName = firstName.capitalized
    self.lastName = lastName.capitalized
    self.location = state.capitalized
    self.pictureUrls = picturesContainer
  }
  
  mutating func setActiveImage(_ image: UIImage?) {
    profilePhoto = image
  }
}
