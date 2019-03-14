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
  
  private var parentNavigationController: SearchNavigationController!
  
  private let model = TimetableModel()
  private let mainView = TimetableView()
  
  override func loadView() {
    super.loadView()
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    parentNavigationController = (navigationController as? SearchNavigationController)
    mainView.setup(dataSource: model.dataSourceHandler)
    
    navigationItem.title = titleName
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
  }
  
  @objc private func onDone() {
    parentNavigationController.popFromTimetable(mainView.getChosenDateTimeInterval())
  }
}
