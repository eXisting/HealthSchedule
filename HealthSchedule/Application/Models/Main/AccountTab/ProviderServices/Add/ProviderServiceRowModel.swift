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
    title: String,
    type: AccountRowType,
    subtype: AccountRowSubtype = .none,
    keyName: String? = nil
    ) {
    self.title = title
    self.keyName = keyName
    self.type = type
    self.subtype = subtype
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

