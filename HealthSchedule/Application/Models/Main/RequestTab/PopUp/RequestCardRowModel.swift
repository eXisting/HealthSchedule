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
  }
}

class RequestCardProviderRowModel: RequestRowDataContaining {
  var data: String
  var title: String = ""
  var additionalData: String?
  var imageUrl: String?
  var rowHeight: CGFloat = 90
  
  init(request: Request) {
    data = request.providerService?.provider?.name ?? "Unknown name"
    additionalData = request.providerService?.provider?.phone
    imageUrl = request.providerService?.provider?.image?.url
  }
}
