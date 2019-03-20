//
//  RequestCardRowModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol RequestRowDataContaining {
  var id: Int? { get set }
  var data: String? { get set }
  var title: String { get }
}

class RequestCardTextRowModel: RequestRowDataContaining {
  var id: Int?
  var data: String?
  var title: String = "Some"
  
}

class RequestCardProviderRowModel: RequestRowDataContaining {
  var id: Int?
  var data: String?
  var title: String = "Any"
  
}
