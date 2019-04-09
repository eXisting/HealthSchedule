//
//  ScheduleModalDayModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class ScheduleModalDayModel {
  var dataSource: ScheduleModalDayDataSource
  
  init(
    startDate: Date,
    tableViewMasterDelegate: TableViewMasteringDelegate,
    _ endDate: Date?,
    _ status: WorkingStatus
  ) {
    dataSource = ScheduleModalDayDataSource(startDate, tableViewMasterDelegate: tableViewMasterDelegate, endDate, status)
  }
  
  func save(errorCall: (String) -> Void, onSuccess: (DefaultEvent) -> Void) {
    if isValidSaveData() {
      let start = dataSource[ScheduleModalDaySectionsIdentifiers.start.rawValue].displayData
      let end = dataSource[ScheduleModalDaySectionsIdentifiers.end.rawValue].displayData
      let status = dataSource[ScheduleModalDaySectionsIdentifiers.status.rawValue].displayData
      
      let startDate = DateManager.shared.stringToDate(start, format: .time, .hour24)
      let endDate = DateManager.shared.stringToDate(end, format: .time, .hour24)

      let newEvent = DefaultEvent(
        id: UUID().uuidString,
        title: "Something",
        startDate: startDate,
        endDate: endDate,
        location: "Any")
      
      onSuccess(newEvent)
    } else {
      errorCall("Start date should be less then end date")
    }
  }
  
  private func isValidSaveData() -> Bool {
    let startDateToEndDate = DateManager.shared.compareDates(
      start: dataSource[ScheduleModalDaySectionsIdentifiers.start.rawValue].displayData,
      end: dataSource[ScheduleModalDaySectionsIdentifiers.end.rawValue].displayData,
      format: .time,
      locale: .hour24
    )

    return startDateToEndDate != .equal || startDateToEndDate != .grater
  }
}
