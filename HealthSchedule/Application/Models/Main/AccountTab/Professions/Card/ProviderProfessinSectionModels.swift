//
//  ProviderProfessinSectionModels.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ProviderProfessionSectionDataContaining: CommonSectionDataContaining, CommonSectionDataActionsHandling {
  subscript(forRowIndex: Int) -> CommonRowDataContaining { get }
}

class ProviderProfessionGeneralSectionModel: ProviderProfessionSectionDataContaining {
  var sectionName: String
  var numberOfRows: Int
  var sectionHeight: CGFloat = 60
  
  private var rows: [CommonRowDataContaining]
  
  init(profession: ProviderProfession?) {
    rows = [
      ProviderProfessionTextRowModel(
        id: profession != nil ? Int(profession!.professionId) : nil,
        data: profession?.profession?.name,
        title: "Profession:",
        type: .general,
        subtype: .professionPicker,
        keyName: ProfessionJsonFields.professionId.rawValue
      ),
      ProviderServiceTextRowModel(
        id: profession != nil ? Int(profession!.city!.id) : nil,
        data: profession != nil ? String(profession!.city!.name!) : nil,
        title: "City:",
        type: .general,
        subtype: .cityPicker,
        keyName: ProfessionJsonFields.cityId.rawValue
      ),
      ProviderServiceTextRowModel(
        data: profession?.companyName,
        title: "Company:",
        type: .general,
        subtype: .none,
        keyName: ProfessionJsonFields.companyName.rawValue
      )
    ]
    
    numberOfRows = rows.count
    sectionName = "General"
  }
  
  subscript(forRowIndex: Int) -> CommonRowDataContaining {
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

class ProviderProfessionTimeIntervalSectionModel: ProviderProfessionSectionDataContaining {
  var sectionName: String
  
  var numberOfRows: Int
  var sectionHeight: CGFloat = 60
  
  private var rows: [CommonRowDataContaining]
  
  init(profession: ProviderProfession?) {
    rows = [
      ProviderProfessioneDateRowModel(
        title: "Start:",
        type: .general,
        subtype: .datePicker,
        keyName: ProfessionJsonFields.startAt.rawValue,
        date: profession?.start
      ),
      ProviderProfessioneDateRowModel(
        title: "End:",
        type: .general,
        subtype: .datePicker,
        keyName: ProfessionJsonFields.endAt.rawValue,
        date: profession?.end
      )
    ]
    
    numberOfRows = rows.count
    sectionName = "Working experience"
  }
  
  subscript(forRowIndex: Int) -> CommonRowDataContaining {
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

