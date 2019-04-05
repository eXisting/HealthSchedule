//
//  ProviderServiceSectionModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ProviderServiceSectionDataContaining: CommonSectionDataContaining {
  var rows: [ProviderServiceRowDataContaining] { get }
  
  subscript(forRowIndex: Int) -> ProviderServiceRowDataContaining { get }
}

class ProviderServiceGeneralSectionModel: ProviderServiceSectionDataContaining {
  var sectionName: String
  var numberOfRows: Int
  var sectionHeight: CGFloat = 60
  
  var rows: [ProviderServiceRowDataContaining]
  
  init() {
    rows = [
      ProviderServiceTextRowModel(title: "Service:"),
      ProviderServiceTextRowModel(title: "Price:"),
      ProviderServiceTextRowModel(title: "Description:")
    ]
    
    numberOfRows = rows.count
    sectionName = "General"
  }
  
  subscript(forRowIndex: Int) -> ProviderServiceRowDataContaining {
    return rows[forRowIndex]
  }
}

class ProviderServiceDurationSectionModel: ProviderServiceSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  var sectionHeight: CGFloat = 60
  
  var rows: [ProviderServiceRowDataContaining]
  
  init() {
    rows = [
      ProviderServiceDateRowModel()
    ]
    
    numberOfRows = rows.count
    sectionName = "Time"
  }
  
  subscript(forRowIndex: Int) -> ProviderServiceRowDataContaining {
    return rows[forRowIndex]
  }
}
