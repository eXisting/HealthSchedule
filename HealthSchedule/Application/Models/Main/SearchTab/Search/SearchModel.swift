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
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  private let commonDataRequestController = CommonDataRequest()
  private let databaseManager = DataBaseManager.shared
  
  var dateTimeInterval: TimetableView.DateTimeInterval?
  var serviceId: Int?
  var cityId: Int?
  
  var searchOptions = [
    SearchOptionKey.service,
    SearchOptionKey.dateTime
  ]
  
  func validateSearchOptions() -> String? {
    guard let _ = serviceId else {
      return ("Choose service!")
    }
    
    guard let _ = dateTimeInterval else {
      return "Choose date and time interval!"
    }
    
    return nil
  }
  
  func startSearch(_ completion: @escaping (String) -> Void) {
    //serviceId!, within: (dateTimeInterval!.startTime, dateTimeInterval!.endTime)) {
    var params: Parser.JsonDictionary = [:]
    params[AvailableTimeJson.serviceId.rawValue] = String(1)//String(serviceId!)
    //params[AvailableTimeJson.cityId.rawValue] = String(2)//String(cityId!)
    params[AvailableTimeJson.dateFrom.rawValue] = DateManager.shared.date2String(with: .date, Date())//DateManager.shared.date2String(with: .date, dateTimeInterval!.startTime)
    params[AvailableTimeJson.dateTo.rawValue] = DateManager.shared.date2String(with: .date, Date().add(component: .day, value: 1))//DateManager.shared.date2String(with: .date, dateTimeInterval!.endTime)
    
    commonDataRequestController.getAvailableTimesList(params, completion)
  }
}