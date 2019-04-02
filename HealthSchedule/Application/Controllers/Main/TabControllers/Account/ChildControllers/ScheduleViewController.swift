//
//  ScheduleViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

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
    title = titleName
  }
}
