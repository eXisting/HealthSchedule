//
//  ScheduleModalDayModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ScheduleModalDayModel {
  var dataSource: ScheduleModalDayDataSource
  private var saveDelegate: ScheduleNavigationItemDelegate
  
  init(
    startDate: Date,
    saveDelegate: ScheduleNavigationItemDelegate,
    tableViewMasterDelegate: TableViewMasteringDelegate,
    _ endDate: Date?,
    _ status: WorkingStatus
  ) {
    dataSource = ScheduleModalDayDataSource(startDate, tableViewMasterDelegate: tableViewMasterDelegate, endDate, status)
    self.saveDelegate = saveDelegate
  }
  
  func save(errorCall: (String) -> Void, onSuccess: () -> Void) {
    if isValidSaveData() {
      saveDelegate.save()
      onSuccess()
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

    return startDateToEndDate == .equal || startDateToEndDate == .grater
  }
}
