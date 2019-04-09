//
//  ScheduleModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class ScheduleModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  private var scheduleDays: [ScheduleDayTemplate] = []
  
  var delegate: ScheduleEventsRefreshing!
  
  var eventsByDate: [Date: [DefaultEvent]] = [:]
  var events: [DefaultEvent] = []
  
  func loadFromCoreData() {
    scheduleDays = DataBaseManager.shared.fetchRequestsHandler.getScheduleDays(context: DataBaseManager.shared.mainContext)
    days2Events()
    delegate.refresh()
  }
  
  func reloadProviderScheduleTemplate(_ completion: @escaping () -> Void) {
    requestManager.getScheduleTemplate {
      response in
      if response == ResponseStatus.success.rawValue {
        completion()
      }
    }
  }
  
  private func days2Events() {
    for day in scheduleDays {
      let event = DefaultEvent(
        id: String(day.id),
        title: "",
        startDate: day.start!,
        endDate: day.end!,
        location: "",
        status: day.working
      )

      events.append(event)
    }
    
    eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
  }
  
  private func saveTemplate(_ completion: @escaping (String) -> Void) {
    // TODO: Save API
    completion(ResponseStatus.success.rawValue)
  }
}

extension ScheduleModel: ScheduleNavigationItemDelegate {
  func save() {
    saveTemplate { status in
      print(status)
    }
  }
}
