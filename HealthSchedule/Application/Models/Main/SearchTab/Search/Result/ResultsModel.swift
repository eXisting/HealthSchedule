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
  private let commonRequestManager = CommonDataRequest()
  
  var tableViewContentHandler: ResultsDataSource!
  var serviceId: Int
  
  private var service: Service!
  
  init(delegate: TableViewSectionsReloading, container: RemoteAvailableTimeContainer, _ serviceId: Int) {
    self.serviceId = serviceId
    
    getServiceData()
    
    var sections: [ResultSectionModel] = []
    for parsedData in container.data {
      sections.append(.init(day: parsedData.0, dayTimes: parsedData.1))
    }
    
    tableViewContentHandler = ResultsDataSource(dataModels: sections, sendRequestHandler: sendRequest)
    tableViewContentHandler.service = service
    tableViewContentHandler.delegate = delegate
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
  
  private func getServiceData() {
    if let coreDataService = DataBaseManager.shared.fetchRequestsHandler.getService(by: serviceId, context: DataBaseManager.shared.mainContext) {
      service = coreDataService
    }
  }
}
