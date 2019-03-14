//
//  AccountModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum AccountSectionNames: String {
  case general = "General"
  case security = "Security"
  case providerData = "Provider data"
  case timetable = "Timetable"
  
  case none = ""
}

enum AccountSectionIdexes: Int {
  case general = 0
  case provider = 1
  case timetable = 2
  case security = 3
}

class AccountModel {
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  private let databaseManager = DataBaseManager.shared
  
  lazy var userData: [AccountSectionNames: [String]] = {
    guard let currentUser = databaseManager.getCurrentUser() else {
      // No user
      return [:]
    }
    
    var result: [AccountSectionNames: [String]] = [:]
    
    result[.general] = [
       currentUser.name ?? "No_name",
       currentUser.city?.name ?? "No_city",
       DateManager.shared.dateToString(currentUser.birthday!)
    ]
    
    result[.security] = [
      currentUser.email ?? "No_email",
      currentUser.phone ?? "",
      "Change password"
    ]
    
    //if currentUser.role?.name == UserTypeName.provider.rawValue {
      result[.providerData] = [
        "Professions",
        "Services",
        "Address",
      ]
      
      result[.timetable] = [
        "Schedule"
      ]
//    }

    return result
  }()
  
  func getUserDataKey(by sectionIndex: Int) -> AccountSectionNames {
    guard let index = AccountSectionIdexes(rawValue: sectionIndex) else {
      return .none
    }
    
    switch index {
      case .general:
        return .general
      case .provider:
        return .providerData
      case .timetable:
        return .timetable
      case .security:
        return .security
    }
  }
  
  func startLoadImage(from url: String?,_ completion: @escaping (Data) -> Void) {
    guard let url = url else {
      return
    }
    
    userRequestController.getImage(from: url) { data in
      completion(data)
    }
  }
}
