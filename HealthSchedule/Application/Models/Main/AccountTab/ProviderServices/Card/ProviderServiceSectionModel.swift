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
  
  init(service: ProviderService?) {
    rows = [
      ProviderServiceTextRowModel(
        data: service?.name,
        title: "Name:",
        type: .general,
        subtype: .none,
        keyName: ProviderServiceJsonFields.name.rawValue
      ),
      ProviderServiceTextRowModel(
        id: service != nil ? Int(service!.serviceId) : nil,
        data: service?.service?.name,
        title: "Service:",
        type: .general,
        subtype: .servicePicker,
        keyName: ProviderServiceJsonFields.serviceId.rawValue
      ),
      ProviderServiceTextRowModel(
        data: service != nil ? String(service!.price) : nil,
        title: "Price:",
        type: .general,
        subtype: .none,
        keyName: ProviderServiceJsonFields.price.rawValue
      ),
      ProviderServiceTextRowModel(
        data: service?.serviceDescription,
        title: "Description:",
        type: .general,
        subtype: .none,
        keyName: ProviderServiceJsonFields.description.rawValue
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
  
  init(service: ProviderService?) {
    rows = [
      ProviderServiceDateRowModel(
        title: "Duration:",
        type: .general,
        subtype: .datePicker,
        keyName: ProviderServiceJsonFields.interval.rawValue,
        date: service?.duration
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
