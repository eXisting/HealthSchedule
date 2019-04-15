//
//  ResultSectionModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

struct ResultSectionModel: CommonSectionDataContaining {
  var numberOfRows: Int
  var sectionName: String
  var sectionHeight: CGFloat = 45
  
  var rows: [ResultRowModel]
  
  init(day: Date, dayTimes: RemoteAvailableTimeContainer.AvailableTimesSortedArray) {
    rows = []
    
    for pair in dayTimes {
      rows.append(.init(pair))
    }
    
    numberOfRows = rows.count
    sectionName = DateManager.shared.date2String(with: .date, day)
  }
}
