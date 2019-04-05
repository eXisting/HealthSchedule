//
//  ProviderServiceRowModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ProviderServiceRowDataContaining: CommonRowDataContaining {
  var rowHeight: CGFloat { get }
}

class ProviderServiceTextRowModel: ProviderServiceRowDataContaining {
  var id: Int?
  var data: String?
  var keyName: String?
  var title: String
  var type: AccountRowType
  var subtype: AccountRowSubtype
  var rowHeight: CGFloat = 65
  
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
      return (key: key, value: data!)
    }
    
    return (key: key, value: String(chosenId))
  }
}

class ProviderServiceDateRowModel: ProviderServiceRowDataContaining {
  var id: Int?
  var data: String?
  var keyName: String?
  var title: String
  var type: AccountRowType
  var subtype: AccountRowSubtype
  var rowHeight: CGFloat = 65
  
  init(
    title: String,
    type: AccountRowType,
    subtype: AccountRowSubtype = .none,
    keyName: String? = nil,
    date: Date? = nil,
    id: Int? = nil
    ) {
    self.title = title
    self.keyName = keyName
    self.type = type
    self.subtype = subtype
    
    self.id = id
    if let serviceDate = date {
      self.data = DateManager.shared.date2String(with: .time, serviceDate, .hour24)
    }
  }
  
  func asKeyValuePair() -> (key: String, value: String) {
    guard let key = keyName else {
      return (key: "", value: "")
    }
    
    guard let chosenId = id else {
      return (key: key, value: data!)
    }
    
    return (key: key, value: String(chosenId))
  }
}

