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
    if scheduleDays.count == 0 {
      reloadProviderScheduleTemplate { [weak self] in
        self?.days2Events()
        self?.delegate.refresh()
      }
      
      return
    }
    
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
    for index in 0..<scheduleDays.count {
      let day = scheduleDays[index]
      
      let event = DefaultEvent(
        id: String(day.id),
        title: "",
        startDate: day.start!,
        endDate: day.end!,
        location: "",
        status: day.working,
        weekDayIndex: index
      )

      events.append(event)
    }
    
    eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
  }
  
  private func collectData() -> Parser.JsonArrayDictionary {
    var result: [Dictionary<String, Any>] = []
    
    for day in events {
      var dict: Dictionary<String, Any> = [:]
      dict[ScheduleTemplateJsonFields.weekDay.rawValue] = day.weekDayIndex
      dict[ScheduleTemplateJsonFields.start.rawValue] = DateManager.shared.date2String(with: .time, day.startDate, .hour24)
      dict[ScheduleTemplateJsonFields.end.rawValue] = DateManager.shared.date2String(with: .time, day.endDate, .hour24)
      dict[ScheduleTemplateJsonFields.working.rawValue] = day.status
      
      result.append(dict)
    }
    
    return [ScheduleTemplateJsonFields.schedules.rawValue: result]
  }
  
  private func saveTemplate(_ completion: @escaping (String) -> Void) {
    requestManager.saveScheduleTemplates(collectData(), completion: completion)
  }
}

extension ScheduleModel: ScheduleNavigationItemDelegate {
  func save() {
    saveTemplate { status in
      print(status)
    }
  }
}
