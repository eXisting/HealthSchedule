//
//  ProviderProfessionRowModels.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderProfessionPickableRowModel: CommonRowDataContaining {
  var id: Int?
  var data: String?
  var keyName: String?
  var title: String
  var type: AccountRowType
  var subtype: AccountRowSubtype
  
  init(
    id: Int? = nil,
    data: String? = nil,
    title: String,
    keyName: String? = nil
    ) {
    self.title = title
    self.keyName = keyName
    self.type = .general
    self.subtype = .none
    
    self.id = id
    self.data = data
  }
  
  func asKeyValuePair() -> (key: String, value: String) {
    guard let key = keyName else {
      return (key: "", value: "")
    }
    
    guard let chosenId = id else {
      return (key: key, value: "")
    }
    
    return (key: key, value: String(chosenId))
  }
}

class ProviderProfessionTextRowModel: CommonRowDataContaining {
  var id: Int?
  var data: String?
  var keyName: String?
  var title: String
  var type: AccountRowType
  var subtype: AccountRowSubtype
  
  init(
    id: Int? = nil,
    data: String? = nil,
    title: String,
    type: AccountRowType,
    subtype: AccountRowSubtype = .none,
    keyName: String? = nil
  ) {
    self.title = title
    self.keyName = keyName
    self.type = type
    self.subtype = subtype
    
    self.id = id
    self.data = data
  }
  
  func asKeyValuePair() -> (key: String, value: String) {
    guard let key = keyName else {
      return (key: "", value: "")
    }
    
    guard let chosenId = id else {
      return (key: key, value: "")
    }
    
    return (key: key, value: String(chosenId))
  }
}

class ProviderProfessioneDateRowModel: CommonRowDataContaining {
  var id: Int?
  var data: String?
  var keyName: String?
  var title: String
  var type: AccountRowType
  var subtype: AccountRowSubtype
  
  init(
    title: String,
    type: AccountRowType,
    subtype: AccountRowSubtype = .none,
    keyName: String,
    date: Date? = nil
  ) {
    self.title = title
    self.keyName = keyName
    self.type = type
    self.subtype = subtype
        
    if let date = date {
      self.data = DateManager.shared.date2String(with: .date, date)
    }
  }
  
  func asKeyValuePair() -> (key: String, value: String) {
    guard let key = keyName else {
      return (key: "", value: "")
    }
    
    guard let date = data else {
      return (key: key, value: "")
    }
    
    return (key: key, value: date)
  }
}
