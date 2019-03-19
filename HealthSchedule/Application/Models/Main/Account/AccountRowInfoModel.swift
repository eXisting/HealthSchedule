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

protocol AccountRowDataContaining {
  var data: String? { get }
  var title: String { get }
  var type: AccountRowType { get }
}

class BaseCellInfo: AccountRowDataContaining {
  var data: String?
  
  var title: String
  
  var type: AccountRowType
  
  init(title: String, type: AccountRowType, data: String? = nil) {
    self.data = data
    self.title = title
    self.type = type
  }
}

