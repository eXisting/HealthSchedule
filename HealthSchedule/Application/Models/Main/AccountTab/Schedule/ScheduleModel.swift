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

  lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
  var events: [DefaultEvent] = []
  
  func loadProviderScheduleTemplate(_ completion: @escaping () -> Void) {
    requestManager.getScheduleTemplate { response in
      if response == ResponseStatus.success.rawValue {
        
      }
    }
  }
  
  private func saveTemplate(_ completion: @escaping (String) -> Void) {
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
