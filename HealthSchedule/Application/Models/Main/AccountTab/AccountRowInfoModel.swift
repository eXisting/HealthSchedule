//
//  AccountRowInfoModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum AccountRowType {
  case profession
  case service
  case address
  case schedule
  case password
  
  case general
}

enum AccountRowSubtype {
  case datePicker
  case cityPicker
  case servicePicker
  case professionPicker
  
  case none
}

protocol CommonRowDataContaining {
  var id: Int? { get set }
  var data: String? { get set }
  var keyName: String? { get }
  var title: String { get }
  var type: AccountRowType { get }
  var subtype: AccountRowSubtype { get }
  
  func asKeyValuePair() -> (key: String, value: String)
}

class BaseCellInfo: CommonRowDataContaining {
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
    keyName: String? = nil,
    data: String? = nil,
    id: Int? = nil
  ) {
    self.id = id
    self.data = data
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
      return (key: key, value: "")
    }
    
    return (key: key, value: String(chosenId))
  }
}

