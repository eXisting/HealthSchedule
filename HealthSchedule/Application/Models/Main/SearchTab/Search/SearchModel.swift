//
//  HomeModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum SearchOptionKey: String {
  case service = "Service"
  case dateTime = "Date and Time"
}

class SearchModel {
  var delegate: TableViewSectionsReloading!
  
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  private let commonDataRequestController = CommonDataRequest()
  var dataSource: SearchDataSource
  
  init() {
    dataSource = SearchDataSource()
    dataSource.deleteHandleFunc = handleChosenOptionDelete
  }
  
  var dateTimeInterval: TimetableView.DateTimeInterval? {
    didSet {
      guard let interval = dateTimeInterval else {
        dataSource.sectionsData[SearchDataSource.SectionsIndexes.chosenOptions.rawValue][SearchDataSource.ChosenOptionsRows.range.rawValue] = ("" as Any)
        delegate.reloadSections(NSIndexSet(index: SearchDataSource.SectionsIndexes.chosenOptions.rawValue) as IndexSet, with: .automatic)
        return
      }
      
      var datesInterval: String = DateManager.shared.date2String(with: .date, interval.start)
      if let end = dateTimeInterval?.end {
        datesInterval.append(" - \(DateManager.shared.date2String(with: .date, end))")
      } else { datesInterval.append(" - end of month") }
      
      let displayText = "Dates interval: \(datesInterval)"
      
      dataSource.sectionsData[SearchDataSource.SectionsIndexes.chosenOptions.rawValue][SearchDataSource.ChosenOptionsRows.range.rawValue] = (displayText as Any)
      delegate.reloadSections(NSIndexSet(index: SearchDataSource.SectionsIndexes.chosenOptions.rawValue) as IndexSet, with: .automatic)
    }
  }
  
  var serviceId: Int? {
    didSet {
      guard let serviceId = serviceId else {
        dataSource.sectionsData[SearchDataSource.SectionsIndexes.chosenOptions.rawValue][SearchDataSource.ChosenOptionsRows.service.rawValue] = ("" as Any)
        delegate.reloadSections(NSIndexSet(index: SearchDataSource.SectionsIndexes.chosenOptions.rawValue) as IndexSet, with: .automatic)
        return
      }
      
      let serviceName = DataBaseManager.shared.fetchRequestsHandler.getService(by: serviceId, context: DataBaseManager.shared.mainContext)!.name!
      let displayText = "Service: \(serviceName)"
      
      dataSource.sectionsData[SearchDataSource.SectionsIndexes.chosenOptions.rawValue][SearchDataSource.ChosenOptionsRows.service.rawValue] = (displayText as Any)
      delegate.reloadSections(NSIndexSet(index: SearchDataSource.SectionsIndexes.chosenOptions.rawValue) as IndexSet, with: .automatic)
    }
  }
  
  var cityId: Int? {
    didSet {
      guard let cityId = cityId else {
        dataSource.sectionsData[SearchDataSource.SectionsIndexes.chosenOptions.rawValue][SearchDataSource.ChosenOptionsRows.city.rawValue] = ("" as Any)
        delegate.reloadSections(NSIndexSet(index: SearchDataSource.SectionsIndexes.chosenOptions.rawValue) as IndexSet, with: .automatic)
        return
      }
      
      let cityName = DataBaseManager.shared.fetchRequestsHandler.getCity(byId: cityId, context: DataBaseManager.shared.mainContext)!.name!
      let displayText = "City: \(cityName)"
      
      dataSource.sectionsData[SearchDataSource.SectionsIndexes.chosenOptions.rawValue][SearchDataSource.ChosenOptionsRows.city.rawValue] = (displayText as Any)
      delegate.reloadSections(NSIndexSet(index: SearchDataSource.SectionsIndexes.chosenOptions.rawValue) as IndexSet, with: .automatic)
    }
  }
  
  func validateSearchOptions() -> String? {
    guard let _ = serviceId else {
      return ("Choose service!")
    }
    
    guard let _ = dateTimeInterval else {
      return "Choose date interval or start date!"
    }
    
    return nil
  }
  
  func startSearch(_ completion: @escaping (RemoteAvailableTimeContainer?) -> Void) {
    var params: Parser.JsonDictionary = [:]
    params[AvailableTimeJson.serviceId.rawValue] = String(serviceId!)
    params[AvailableTimeJson.cityId.rawValue] = String(cityId!)
    params[AvailableTimeJson.dateFrom.rawValue] = DateManager.shared.date2String(with: .date, dateTimeInterval!.start)
    
    if let endDate = dateTimeInterval?.end {
      params[AvailableTimeJson.dateTo.rawValue] = DateManager.shared.date2String(with: .date, endDate)      
    }
    
    commonDataRequestController.getAvailableTimesList(params, completion)
  }
  
  private func handleChosenOptionDelete(_ option: SearchDataSource.ChosenOptionsRows) {
    switch option {
    case .city, .service:
      cityId = nil
      serviceId = nil
    case .range:
      dateTimeInterval = nil
    }
  }
}
