//
//  TimetableView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FSCalendar

class TimetableView: UIView {
  private let container = UIStackView()

  typealias DateTimeInterval = (start: Date, end: Date?)
  
  let calendar = FSCalendar()
 
  let startlabel = UILabel()
  let endlabel = UILabel()

  func setup(dataSource: FSCalendarDataSource, delegate: FSCalendarDelegate) {
    laidOutViews()
    customizeViews()
    
    calendar.dataSource = dataSource
    calendar.delegate = delegate
  }
  
  func getChosenDateTimeInterval() -> DateTimeInterval? {
    let days = calendar.selectedDates.sorted(by: { $0 < $1 } )
    
    guard let start = days.first else {
      return nil
    }
    
    if days.count == 2 {
      return (start, days.last!)
    }
    
    return (start, nil)
  }
  
  func updateLabels(_ dates: [Date]) {
    if dates.count == 1 {
      startlabel.text = "Start: \(DateManager.shared.date2String(with: .date, dates.first!))"
      endlabel.text = ""
      return
    }
    
    startlabel.text = dates.first == nil ? "" : "Start: \(DateManager.shared.date2String(with: .date, dates.first!))"
    endlabel.text = dates.last == nil ? "" : "End: \(DateManager.shared.date2String(with: .date, dates.last!))"
  }
  
  private func laidOutViews() {
    addSubview(calendar)
    addSubview(container)
    
    container.addArrangedSubview(startlabel)
    container.addArrangedSubview(endlabel)

    calendar.translatesAutoresizingMaskIntoConstraints = false
    container.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: calendar, attribute: .top, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0).isActive = true

    NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: calendar, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: calendar, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.2, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    container.axis = .vertical
    container.distribution = .fillEqually
    container.alignment = .fill
    
    calendar.scrollDirection = .vertical
    calendar.allowsMultipleSelection = true
  }
}
