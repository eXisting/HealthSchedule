//
//  RequestCardSection.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol RequestSectionDataContaining: CommonSectionDataContaining {
  var rows: [RequestRowDataContaining] { get }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining { get }
}

class RequestCardProviderSectionModel: RequestSectionDataContaining {
  var numberOfRows: Int
  var sectionHeight: CGFloat = 10
  var sectionName: String = ""
  
  var rows: [RequestRowDataContaining]
  
  init(request: RemoteRequest) {
    rows = [
      RequestCardProviderRowModel(request: request)
    ]
    
    numberOfRows = rows.count
  }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining {
    return rows[forRowIndex]
  }
}

class RequestCardScheduleSectionModel: RequestSectionDataContaining {
  var numberOfRows: Int
  var sectionHeight: CGFloat = 10
  var sectionName: String = ""
  
  var rows: [RequestRowDataContaining]
  
  init(request: RemoteRequest) {
    rows = [
      RequestCardTextRowModel(title: "Address", data: request.providerService.address.address),
      RequestCardTextRowModel(title: "Date", data: DateManager.shared.date2String(with: .humanDateTime, request.requestAt, .hour24))
    ]
    
    numberOfRows = rows.count
  }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining {
    return rows[forRowIndex]
  }
}

class RequestCardInfoSectionModel: RequestSectionDataContaining {
  var numberOfRows: Int
  var sectionHeight: CGFloat = 10
  var sectionName: String = ""
  
  var rows: [RequestRowDataContaining]
  
  init(request: RemoteRequest) {
    rows = [
      RequestCardTextRowModel(title: "Service", data: request.providerService.service.title),
      RequestCardTextRowModel(title: "Price", data: String(request.providerService.price)),
      RequestCardTextRowModel(title: "Duration", data:  DateManager.shared.date2String(with: .time, request.providerService.interval, .hour24)),
      RequestCardTextRowModel(title: "Description", data: request.description)
    ]
    
    numberOfRows = rows.count
  }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining {
    return rows[forRowIndex]
  }
}
