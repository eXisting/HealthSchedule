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
  
  init(request: Request) {
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
  
  init(request: Request) {
    rows = [
      RequestCardTextRowModel(title: "Address", data: request.providerService?.address?.address ?? "Address unknown"),
      RequestCardTextRowModel(title: "Date", data: DateManager.shared.date2String(with: .humanDateTime, request.requestedAt!, .hour24))
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
  
  init(request: Request) {
    rows = [
      RequestCardTextRowModel(title: "Service", data: request.providerService?.name ?? request.service?.name ?? "Title unknown"),
      RequestCardTextRowModel(title: "Price", data: String(request.providerService?.price ?? 0.0)),
      RequestCardTextRowModel(title: "Duration", data:  DateManager.shared.date2String(with: .time, request.providerService?.duration ?? Date(), .hour24)),
      RequestCardTextRowModel(title: "Description", data: request.requestDescription ?? "No description")
    ]
    
    numberOfRows = rows.count
  }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining {
    return rows[forRowIndex]
  }
}
