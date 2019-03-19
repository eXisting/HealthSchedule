//
//  AccountSectionInfoModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AccountSectionDataContaining {
  var numberOfRows: Int { get }
  var sectionName: String { get }
  subscript(forRowIndex: Int) -> AccountRowDataContaining { get }
}

class GeneralInfoAccountSectionModel: AccountSectionDataContaining {
  
  var sectionName: String
  
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> AccountRowDataContaining {
    return rows[forRowIndex]
  }
  
  private let rows: [AccountRowDataContaining]
  
  init(user: User) {
    rows = [
      BaseCellInfo(title: "Full name:", type: .general, data: user.name),
      BaseCellInfo(title: "City:", type: .general, data: user.city?.name),
      BaseCellInfo(title: "Birthday:", type: .general, data: DateManager.shared.dateToString(user.birthday!))
    ]
    
    sectionName = "General"
    numberOfRows = rows.count
  }
}


class ProviderInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> AccountRowDataContaining {
    return rows[forRowIndex]
  }
  
  private let rows: [AccountRowDataContaining]
  
  init(user: User) {
    rows = [
      BaseCellInfo(title: "Professions", type: .profession),
      BaseCellInfo(title: "Address", type: .address),
      BaseCellInfo(title: "Services", type: .service),
      BaseCellInfo(title: "Schedule", type: .schedule)
    ]
    
    sectionName = "Provider data"
    numberOfRows = rows.count
  }
}

class SecureInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> AccountRowDataContaining {
    return rows[forRowIndex]
  }
  
  private let rows: [AccountRowDataContaining]
  
  init(user: User) {
    rows = [
      BaseCellInfo(title: "Email:", type: .general, data: user.email),
      BaseCellInfo(title: "Phone:", type: .general, data: user.phone),
      BaseCellInfo(title: "Password", type: .password)
    ]
    
    sectionName = "Security"
    numberOfRows = rows.count
  }
}

