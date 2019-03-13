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
  
  private let mainView = TimetableView()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.setup(delegate: self, dataSource: self)
    navigationItem.title = titleName
  }
}

extension TimetableViewController: FSCalendarDelegate, FSCalendarDataSource {
  
}
