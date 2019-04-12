//
//  SearchTimeElement.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum AvailableTimeJson: String {
  case cityId = "city_id"
  case serviceId = "serivce_id"
  case dateFrom = "date_from"
  case dateTo = "date_to"

  case times = "times"
  case date = "date"
}

struct RemoteAvailableTimeContainer {
  typealias AvailableDatesSortedArray = [(Date, AvailableTimesSortedArray)]
  typealias AvailableTimesSortedArray = [(Date, [Int])]
  
  private var parsedResponse: AvailableDatesSortedArray
  
  var data: AvailableDatesSortedArray { get { return parsedResponse } }
  
  init(json: Any) {
    parsedResponse = Parser.processAvailableTimes(json)
  }
  
  func getDates() -> [Date] {
    return data.map( { $0.0 } )
  }
  
  func getTimesWithIds(for date: Date) -> AvailableTimesSortedArray {
    return data.first(where: { return $0.0 == date } )?.1 ?? []
  }
  
  func printAllKeys() {
    data.forEach({print($0.0)})
  }
}
