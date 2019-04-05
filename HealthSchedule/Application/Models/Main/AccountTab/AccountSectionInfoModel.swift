//
//  AccountSectionInfoModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol CommonSectionDataContaining {
  var numberOfRows: Int { get }
  var sectionName: String { get }
  var sectionHeight: CGFloat { get }
}

protocol CommonSectionDataActionsHandling {
  func set(data: String?, for rowAtIndex: Int)
  func set(id: Int, for rowAtIndex: Int)
  func asJson() -> Parser.JsonDictionary
}

protocol AccountSectionDataContaining: CommonSectionDataContaining, CommonSectionDataActionsHandling {
  subscript(forRowIndex: Int) -> CommonRowDataContaining { get }
}

class GeneralInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  var sectionHeight: CGFloat = 55
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> CommonRowDataContaining {
    return rows[forRowIndex]
  }
  
  private var rows: [CommonRowDataContaining]
  
  init(user: User) {
    guard let city = user.city,
      let birthday = user.birthday else {
      fatalError("User cannot exist without city or birthday date")
    }
    
    rows = [
      BaseCellInfo(title: "Full name:", type: .general, keyName: "fullName", data: user.name),
      BaseCellInfo(title: "City:", type: .general, subtype: .cityPicker, keyName: "city_id", data: city.name, id: Int(city.id)),
      BaseCellInfo(title: "Birthday:", type: .general, subtype: .datePicker, keyName: "birthday_at", data: DateManager.shared.dateToString(birthday))
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
  
  func asJson() -> Parser.JsonDictionary {
    var result: Parser.JsonDictionary = [:]
    
    rows.forEach { row in
      let rowJson = row.asKeyValuePair()
      result[rowJson.key] = rowJson.value
    }
    
    return result
  }
}


class ProviderInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  var sectionHeight: CGFloat = 55
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> CommonRowDataContaining {
    return rows[forRowIndex]
  }
  
  private var rows: [CommonRowDataContaining]
  
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
  
  func asJson() -> Parser.JsonDictionary { return [:] }
  func set(data: String?, for rowAtIndex: Int) {}
  func set(id: Int, for rowAtIndex: Int) {}
}

class SecureInfoAccountSectionModel: AccountSectionDataContaining {
  var sectionName: String
  var sectionHeight: CGFloat = 55
  var numberOfRows: Int
  
  subscript(forRowIndex: Int) -> CommonRowDataContaining {
    return rows[forRowIndex]
  }
  
  private var rows: [CommonRowDataContaining]
  
  init(user: User) {
    rows = [
      BaseCellInfo(title: "Email:", type: .general, keyName: "email", data: user.email),
      BaseCellInfo(title: "Phone:", type: .general, keyName: "phone", data: user.phone),
      BaseCellInfo(title: "Password", type: .password)
    ]
    
    sectionName = "Security"
    numberOfRows = rows.count
  }
  
  func set(data: String?, for rowAtIndex: Int) {
    rows[rowAtIndex].data = data
  }
  
  func asJson() -> Parser.JsonDictionary {
    var result: Parser.JsonDictionary = [:]
    
    rows.forEach { row in
      let rowJson = row.asKeyValuePair()
      if !rowJson.key.isEmpty {
        result[rowJson.key] = rowJson.value
      }     
    }
    
    return result
  }
  
  func set(id: Int, for rowAtIndex: Int) {}
}
