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
  func set(data: String?, for rowAtIndex: Int)
  func set(id: Int, for rowAtIndex: Int)
}

class GeneralInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> AccountRowDataContaining {
    return rows[forRowIndex]
  }
  
  private var rows: [AccountRowDataContaining]
  
  init(user: User) {
    rows = [
      BaseCellInfo(title: "Full name:", type: .general, data: user.name),
      BaseCellInfo(title: "City:", type: .general, subtype: .cityPicker, data: user.city?.name),
      BaseCellInfo(title: "Birthday:", type: .general, subtype: .datePicker, data: DateManager.shared.dateToString(user.birthday!))
    ]
    
    sectionName = "General"
    numberOfRows = rows.count
  }
  
  func set(data: String?, for rowAtIndex: Int) {
    rows[rowAtIndex].data = data
  }
  
  func set(id: Int, for rowAtIndex: Int) {
    rows[rowAtIndex].id = id
  }
}


class ProviderInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> AccountRowDataContaining {
    return rows[forRowIndex]
  }
  
  private var rows: [AccountRowDataContaining]
  
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
  
  func set(data: String?, for rowAtIndex: Int) {}
  func set(id: Int, for rowAtIndex: Int) {}
}

class SecureInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> AccountRowDataContaining {
    return rows[forRowIndex]
  }
  
  private var rows: [AccountRowDataContaining]
  
  init(user: User) {
    rows = [
      BaseCellInfo(title: "Email:", type: .general, data: user.email),
      BaseCellInfo(title: "Phone:", type: .general, data: user.phone),
      BaseCellInfo(title: "Password", type: .password)
    ]
    
    sectionName = "Security"
    numberOfRows = rows.count
  }
  
  func set(data: String?, for rowAtIndex: Int) {
    rows[rowAtIndex].data = data
  }
  
  func set(id: Int, for rowAtIndex: Int) {}
}

