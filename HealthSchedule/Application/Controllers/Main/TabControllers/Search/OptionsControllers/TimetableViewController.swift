//
//  TimetableViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import CDAlertView
import FSCalendar

class TimetableViewController: UIViewController {
  private let titleName = "Date and Time"
  
  private let model = TimetableModel()
  private let mainView = TimetableView()
  
  var delegate: SearchPickResponsible?
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.setup(dataSource: model.dataSourceHandler, delegate: self)
    
    navigationItem.title = titleName
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
  }
  
  @objc private func onDone() {
    guard let dateTimeInterval = mainView.getChosenDateTimeInterval() else {
      showWarningAlert(message: "You must choose start date at least!")
      return
    }
        
    delegate?.pickHandler(from: .dateTime, data: dateTimeInterval as Any)    
  }
}

extension TimetableViewController: FSCalendarDelegate {
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    let sortedSelectedDates = calendar.selectedDates.sorted(by: { $0 < $1 })
    
    if sortedSelectedDates.count == 2 {
      calendar.deselect(date < sortedSelectedDates.first! ? sortedSelectedDates.first! : sortedSelectedDates.last!)
    }
    
    return true
  }
  
  func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    let sortedSelectedDates = calendar.selectedDates.sorted(by: { $0 < $1 })
    mainView.updateLabels(sortedSelectedDates)
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    let sortedSelectedDates = calendar.selectedDates.sorted(by: { $0 < $1 })
    mainView.updateLabels(sortedSelectedDates)
  }
}

extension TimetableViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    CDAlertView(title: "Warning", message: message, type: .warning).show()
  }
}
