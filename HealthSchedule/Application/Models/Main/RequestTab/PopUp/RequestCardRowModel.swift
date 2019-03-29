//
//  RequestCardRowModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol RequestRowDataContaining {
  var data: String { get }
  var title: String { get }
  var rowHeight: CGFloat { get }
}

class RequestCardTextRowModel: RequestRowDataContaining {
  var data: String
  var title: String
  var rowHeight: CGFloat = 50
  
  init(title: String, data: String) {
    self.title = title
    self.data = data
    
//    if data.count > 50 {
//      rowHeight = 300
//    }
  }
}

class RequestCardProviderRowModel: RequestRowDataContaining {
  var data: String
  var title: String = ""
  var additionalData: String?
  var imageUrl: String?
  var rowHeight: CGFloat = 90
  
  init(request: Request) {
    data = "Unknown name"
    additionalData = "Unknown phone" //request.providerService.provider?.phone
    imageUrl = "https://www.icpdas-usa.com/icons/login-icon.png" // TODO: rewrite request cause it does not send photo //request.providerService.provider?.photo?.url
  }
}
