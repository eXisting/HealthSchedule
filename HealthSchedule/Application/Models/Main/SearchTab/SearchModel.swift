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
  
  var dateTimeInterval: (day: Date, start: Date, end: Date)?
  var serviceId: Int?
  
  var searchOptions = [
    SearchOptionKey.service,
    SearchOptionKey.dateTime
  ]
  
  func getSearchOptions() -> (errorMessage: String?, [String: Any]) {
    guard let service = serviceId else {
      return (errorMessage: "Choose service!", [:])
    }
    
    guard let interval = dateTimeInterval else {
      return (errorMessage: "Choose date and time interval!", [:])
    }
    
    let startDateTime = DateManager.shared.combineDateWithTime(date: interval.day, time: interval.start)
    let endDateTime = DateManager.shared.combineDateWithTime(date: interval.day, time: interval.end)
    
    return (nil, ["serviceId": service, "start": startDateTime as Any, "end": endDateTime as Any])
  }
}
