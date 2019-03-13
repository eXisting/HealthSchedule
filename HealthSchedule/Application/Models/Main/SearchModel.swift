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
  case provider = "Specialist"
}

class SearchModel {
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  private let commonDataRequestController = CommonDataRequest()
  private let databaseManager = DataBaseManager.shared
  
  var date: Date?
  var serviceId: Int?
  var providerId: Int?
  
  var searchOptions = [
    SearchOptionKey.service,
    SearchOptionKey.dateTime
  ]
}
