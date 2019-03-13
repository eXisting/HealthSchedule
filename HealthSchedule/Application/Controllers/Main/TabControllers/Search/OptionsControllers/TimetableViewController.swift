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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = titleName
    
    let calendar = FSCalendar(frame: CGRect(x: 30, y: 300, width: self.view.frame.width * 0.9, height: 300))
    calendar.dataSource = self
    calendar.delegate = self
    view.addSubview(calendar)
  }
}

extension TimetableViewController: FSCalendarDelegate, FSCalendarDataSource {
  
}
