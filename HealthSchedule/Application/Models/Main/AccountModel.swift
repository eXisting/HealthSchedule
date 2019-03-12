//
//  AccountModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountModel {
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  private let databaseManager = DataBaseManager.shared
  
  lazy var userData: [(sectionName: String, rowValue: String)]? = {
    guard let currentUser = databaseManager.getCurrentUser() else {
      // return all from core data
      return nil
    }
    
    var result: [(sectionName: String, rowValue: String)] = []
    result.append(("Full name", currentUser.name ?? "No_name"))
    result.append(("City", currentUser.city?.name ?? "No_city"))
    result.append(("Birthday", DateManager.shared.dateToString(currentUser.birthday!)))
    result.append(("E-mail", currentUser.email ?? "No_email"))
    result.append(("Phone", currentUser.phone ?? ""))
    
    return result
  }()
  
  func startLoadImage(from url: String,_ completion: @escaping (Data) -> Void) {
    userRequestController.getImage(from: url) { data in
      completion(data)
    }
  }
}
