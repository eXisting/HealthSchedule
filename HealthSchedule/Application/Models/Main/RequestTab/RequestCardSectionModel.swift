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
  var sectionName: String = ""
  
  var rows: [RequestRowDataContaining]
  
  init(request: RemoteRequest) {
    rows = [
      RequestCardProviderRowModel()
    ]
    
    numberOfRows = rows.count
  }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining {
    return rows[forRowIndex]
  }
}

class RequestCardScheduleSectionModel: RequestSectionDataContaining {
  var numberOfRows: Int
  var sectionName: String = ""
  
  var rows: [RequestRowDataContaining]
  
  init(request: RemoteRequest) {
    rows = [
      RequestCardTextRowModel(),
      RequestCardTextRowModel()
    ]
    
    numberOfRows = rows.count
  }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining {
    return rows[forRowIndex]
  }
}

class RequestCardInfoSectionModel: RequestSectionDataContaining {
  var numberOfRows: Int
  var sectionName: String = ""
  
  var rows: [RequestRowDataContaining]
  
  init(request: RemoteRequest) {
    rows = [
      RequestCardTextRowModel(),
      RequestCardTextRowModel(),
      RequestCardTextRowModel()
    ]
    
    numberOfRows = rows.count
  }
  
  subscript(forRowIndex: Int) -> RequestRowDataContaining {
    return rows[forRowIndex]
  }
}
