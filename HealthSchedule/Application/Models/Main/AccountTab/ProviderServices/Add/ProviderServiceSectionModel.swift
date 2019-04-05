//
//  ProviderServiceSectionModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ProviderServiceSectionDataContaining: CommonSectionDataContaining, CommonSectionDataActionsHandling {
  subscript(forRowIndex: Int) -> ProviderServiceRowDataContaining { get }
}

class ProviderServiceGeneralSectionModel: ProviderServiceSectionDataContaining {
  var sectionName: String
  var numberOfRows: Int
  var sectionHeight: CGFloat = 60
  
  private var rows: [ProviderServiceRowDataContaining]
  
  init() {
    rows = [
      ProviderServiceTextRowModel(
        title: "Service:",
        type: .general,
        subtype: .servicePicker,
        keyName: ProviderServiceJsonFields.interval.rawValue
      ),
      ProviderServiceTextRowModel(
        title: "Price:",
        type: .general,
        subtype: .none,
        keyName: ProviderServiceJsonFields.interval.rawValue
      ),
      ProviderServiceTextRowModel(
        title: "Description:",
        type: .general,
        subtype: .none,
        keyName: ProviderServiceJsonFields.interval.rawValue
      )
    ]
    
    numberOfRows = rows.count
    sectionName = "General"
  }
  
  subscript(forRowIndex: Int) -> ProviderServiceRowDataContaining {
    return rows[forRowIndex]
  }
  
  func set(data: String?, for rowAtIndex: Int) {
    rows[rowAtIndex].data = data
  }
  
  func set(id: Int, for rowAtIndex: Int) {
    rows[rowAtIndex].id = id
  }
  
  func asJson() -> Parser.JsonDictionary {
    var result: Parser.JsonDictionary = [:]
    
    rows.forEach { row in
      let rowJson = row.asKeyValuePair()
      if !rowJson.key.isEmpty {
        result[rowJson.key] = rowJson.value
      }
    }
    
    return result
  }
}

class ProviderServiceDurationSectionModel: ProviderServiceSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  var sectionHeight: CGFloat = 60
  
  private var rows: [ProviderServiceRowDataContaining]
  
  init() {
    rows = [
      ProviderServiceDateRowModel(
        title: "Duration:",
        type: .general,
        subtype: .datePicker,
        keyName: ProviderServiceJsonFields.interval.rawValue
      )
    ]
    
    numberOfRows = rows.count
    sectionName = "Time"
  }
  
  subscript(forRowIndex: Int) -> ProviderServiceRowDataContaining {
    return rows[forRowIndex]
  }
  
  func set(data: String?, for rowAtIndex: Int) {
    rows[rowAtIndex].data = data
  }
  
  func set(id: Int, for rowAtIndex: Int) {
    rows[rowAtIndex].id = id
  }
  
  func asJson() -> Parser.JsonDictionary {
    var result: Parser.JsonDictionary = [:]
    
    rows.forEach { row in
      let rowJson = row.asKeyValuePair()
      if !rowJson.key.isEmpty {
        result[rowJson.key] = rowJson.value
      }
    }
    
    return result
  }
}
