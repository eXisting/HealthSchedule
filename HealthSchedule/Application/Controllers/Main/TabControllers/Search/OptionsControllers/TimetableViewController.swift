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
    mainView.setup(delegate: self, dataSource: model.dataSourceHandler)
    
    navigationItem.title = titleName
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))
    mainView.chooseTimeButton.addTarget(self, action: #selector(onChooseTimeClick), for: .touchDown)
  }
  
  @objc private func onDone() {
    let collector = parentNavigationController.getCollector()
    collector.storeDate(mainView.getChosenDate())
    parentNavigationController.popViewController(animated: true)
  }
  
  @objc private func onChooseTimeClick() {
    // TODO
  }
}

extension TimetableViewController: FSCalendarDelegate {
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    print(DateManager.shared.dateToString(date))
  }
}
