//
//  ResultsModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ResultsModel {
  private var container: RemoteAvailableTimeContainer
  
  var tableViewContentHandler: ResultsTableViewHandler
  
  init(container: RemoteAvailableTimeContainer) {
    self.container = container
    
    var sections: [ResultSectionModel] = []
    for parsedData in self.container.data {
      sections.append(.init(day: parsedData.0, dayTimes: parsedData.1))
    }
    
    tableViewContentHandler = ResultsTableViewHandler(dataModels: sections)
  }
}
