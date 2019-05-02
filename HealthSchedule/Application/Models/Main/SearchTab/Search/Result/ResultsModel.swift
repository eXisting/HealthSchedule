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
  
  private var service: Service!

  var tableViewContentHandler: ResultsDataSource!
  var serviceId: Int
  
  init(reloadDelegate: TableViewSectionsReloading, loaderDelegate: LoaderShowable, viewDelegate: PushingUserControllerDelegate, container: RemoteAvailableTimeContainer, _ serviceId: Int) {
    self.serviceId = serviceId
    
    getServiceData()
    
    var sections: [ResultSectionModel] = []
    for parsedData in container.data {
      sections.append(.init(day: parsedData.0, dayTimes: parsedData.1))
    }
    
    tableViewContentHandler = ResultsDataSource(dataModels: sections)
    tableViewContentHandler.service = service
    tableViewContentHandler.reloadDelegate = reloadDelegate
    tableViewContentHandler.loaderDelegate = loaderDelegate
    tableViewContentHandler.viewDetailsDelegate = viewDelegate
  }
  
  private func getServiceData() {
    if let coreDataService = DataBaseManager.shared.fetchRequestsHandler.getService(by: serviceId, context: DataBaseManager.shared.mainContext) {
      service = coreDataService
    }
  }
}
