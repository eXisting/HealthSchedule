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
  
  case none
}

protocol AccountRowDataContaining {
  var id: Int? { get set }
  var data: String? { get set }
  var title: String { get }
  var type: AccountRowType { get }
  var subtype: AccountRowSubtype { get }
}

class BaseCellInfo: AccountRowDataContaining {
  var id: Int?
  
  var data: String?
  
  var title: String
  
  var type: AccountRowType
  
  var subtype: AccountRowSubtype

  init(title: String, type: AccountRowType, subtype: AccountRowSubtype = .none, data: String? = nil, id: Int? = nil) {
    self.id = id
    self.data = data
    self.title = title
    self.type = type
    self.subtype = subtype
  }
}

