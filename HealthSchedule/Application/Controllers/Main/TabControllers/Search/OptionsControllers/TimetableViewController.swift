//
//  TimetableViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
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
    mainView.setup(dataSource: model.dataSourceHandler)
    
    navigationItem.title = titleName
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
  }
  
  @objc private func onDone() {
    let dateTimeInterval = mainView.getChosenDateTimeInterval()
    if dateTimeInterval.endTime < dateTimeInterval.startTime {
      showWarningAlert(message: "End time cannot be grater then start time!")
      return
    }
    
    delegate?.pickHandler(from: .dateTime, data: dateTimeInterval as Any)    
  }
}

extension TimetableViewController: ErrorShowable {
  func showWarningAlert(message: String) {
    AlertHandler.ShowAlert(
      for: self,
      "Warning",
      message,
      .alert)
  }
}
