//
//  ScheduleViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FSCalendar

protocol ScheduleNavigationItemDelegate {
  func save()
}

class ScheduleViewController: UIViewController {
  private let titleName = "Schedule"
  
  private let mainView = ScheduleMainView()
  private let model = ScheduleModel()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(timeViewDataSource: model.timetableDataSource, timeViewDelegate: self)
    title = titleName
  }
  
  private var customNavigationItem: ScheduleNavigationItem?
  
  override var navigationItem: UINavigationItem {
    get {
      if customNavigationItem == nil {
        customNavigationItem = ScheduleNavigationItem(title: titleName, delegate: self)
      }
      
      return customNavigationItem!
    }
  }
}

extension ScheduleViewController: FSCalendarDelegate {
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    model.onDatePicked(date: date)
  }
  
  func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    calendar.deselect(date)
    model.onDateDeselected(date: date)
  }
}

extension ScheduleViewController: ScheduleNavigationItemDelegate {
  func save() {
    
  }
}
