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
        self?.scheduleDays = DataBaseManager.shared.fetchRequestsHandler.getScheduleDays(context: DataBaseManager.shared.mainContext)
        self?.days2Events()
        
        DispatchQueue.main.async {
          self?.delegate.refresh()
        }
      }
      return
    }
    
    days2Events()
    eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
    
    DispatchQueue.main.async {
      self.delegate.refresh()
    }
  }
  
  func reloadProviderScheduleTemplate(_ completion: @escaping () -> Void) {
    requestManager.getScheduleTemplate {
      response in
      if response == ResponseStatus.success.rawValue {
        completion()
      }
    }
  }
  
  func insertUpdateEvent(_ newEvent: DefaultEvent) {
    if let index = events.firstIndex(where: { $0.weekDayIndex == newEvent.weekDayIndex }) {
      events[index] = newEvent
      return
    }
    
    events.append(newEvent)
  }
  
  private func days2Events() {
    for day in scheduleDays {
      let event = DefaultEvent(
        id: String(day.id),
        title: "",
        startDate: day.start!,
        endDate: day.end!,
        location: "",
        status: day.working,
        weekDayIndex: Int(day.weekDayIndex)
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
  
  func saveTemplate(_ completion: @escaping (String) -> Void) {
    requestManager.saveScheduleTemplates(collectData(), completion: completion)
  }
}
