//
//  ScheduleModalDayModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import JZCalendarWeekView

enum WorkingStatus: String {
  case working = "Working"
  case off = "Not working"
}

class ScheduleModalDayModel {
  private var chosenStartDate: Date
  var dataSource: ScheduleModalDayDataSource
  
  init(startDate: Date, tableViewMasterDelegate: TableViewMasteringDelegate, _ endDate: Date?, _ status: WorkingStatus) {
    chosenStartDate = startDate
    dataSource = ScheduleModalDayDataSource(chosenStartDate, tableViewMasterDelegate: tableViewMasterDelegate, endDate, status)
  }
  
  func save(errorCall: (String) -> Void, onSuccess: (DefaultEvent) -> Void) {
    if isValidSaveData() {
      let start = dataSource[ScheduleModalDaySectionsIdentifiers.start.rawValue].displayData
      let end = dataSource[ScheduleModalDaySectionsIdentifiers.end.rawValue].displayData
      let status = dataSource[ScheduleModalDaySectionsIdentifiers.status.rawValue].displayData
      
      let startTime = DateManager.shared.stringToDate(start, format: .time, .hour24)
      let endTime = DateManager.shared.stringToDate(end, format: .time, .hour24)
      
      guard let startDate = DateManager.shared.combineDateWithTime(date: chosenStartDate, time: startTime),
        let endDate = DateManager.shared.combineDateWithTime(date: chosenStartDate, time: endTime) else {
          print("Cannot combine dates!")
          return
      }

      let newEvent = DefaultEvent(
        id: UUID().uuidString,
        title: "",
        startDate: startDate,
        endDate: endDate,
        location: "",
        status: statusName2Bool(status),
        weekDayIndex: DateManager.shared.date2WeekDayIndex(chosenStartDate)
      )
      
      onSuccess(newEvent)
    } else {
      errorCall("Start date should be less then end date")
    }
  }
  
  private func statusName2Bool(_ name: String) -> Bool {
    return name == WorkingStatus.working.rawValue
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
