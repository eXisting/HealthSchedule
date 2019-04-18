//
//  ResultsModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ResultsModel {
  private let requestManager: UserDataUpdating = UserDataRequest()
  
  var tableViewContentHandler: ResultsTableViewHandler!
  var serviceId: Int
  
  init(container: RemoteAvailableTimeContainer, _ serviceId: Int) {
    self.serviceId = serviceId
    
    var sections: [ResultSectionModel] = []
    for parsedData in container.data {
      sections.append(.init(day: parsedData.0, dayTimes: parsedData.1))
    }
    
    tableViewContentHandler = ResultsTableViewHandler(dataModels: sections, sendRequestHandler: sendRequest)
  }
  
  func sendRequest(providerId: Int, time: Date) {
    var data: Parser.JsonDictionary = [:]
    data[RequestJsonFields.requestAt.rawValue] = DateManager.shared.date2String(with: .dateTime, time)
    data[ProviderServiceJsonFields.providerId.rawValue] = String(providerId)
    data[ProviderServiceJsonFields.serviceId.rawValue] = String(serviceId)
    data[RequestJsonFields.description.rawValue] = "Hello, I would like to book!"
    
    requestManager.makeRequests(toProviderWith: data) { response in
      print(response)
    }
  }
}
