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
  private let calendar = FSCalendar()
  private let timeLabel = UILabel()
  let chooseTimeButton = UIButton()

  func setup(delegate: FSCalendarDelegate, dataSource: FSCalendarDataSource) {
    laidOutViews()
    customizeViews()
    
    calendar.dataSource = dataSource
    calendar.delegate = delegate
  }
  
  func getChosenDate() -> Date {
    return calendar.selectedDate ?? calendar.today ?? Date()
  }
  
  private func laidOutViews() {
    addSubview(calendar)
    addSubview(timeLabel)
    addSubview(chooseTimeButton)

    calendar.translatesAutoresizingMaskIntoConstraints = false
    chooseTimeButton.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: calendar, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
    
    NSLayoutConstraint(item: timeLabel, attribute: .top, relatedBy: .equal, toItem: calendar, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: timeLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: timeLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
    NSLayoutConstraint(item: timeLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
    
    NSLayoutConstraint(item: chooseTimeButton, attribute: .top, relatedBy: .equal, toItem: timeLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: chooseTimeButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: chooseTimeButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.05, constant: 0).isActive = true
    NSLayoutConstraint(item: chooseTimeButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.6, constant: 0).isActive = true
    NSLayoutConstraint(item: chooseTimeButton, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -16).isActive = true
  }
  
  private func customizeViews() {
    chooseTimeButton.roundBorder()
    chooseTimeButton.setTitle("CHOOSE TIME INTERVAL", for: .normal)
    chooseTimeButton.layer.borderColor = UIColor.black.cgColor
    chooseTimeButton.setTitleColor(.black, for: .normal)
    
    timeLabel.text = "From: 00:00 To: 23:59"
    timeLabel.textAlignment = .center
    timeLabel.adjustsFontSizeToFitWidth = true
    timeLabel.adjustsFontForContentSizeCategory = true
  }
}
