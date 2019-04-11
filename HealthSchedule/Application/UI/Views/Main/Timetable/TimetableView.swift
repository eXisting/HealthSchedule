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
  typealias DateTimeInterval = (day: Date, startTime: Date, endTime: Date)
  
  let calendar = FSCalendar()
  
  private let timePickerContainer = UIView()
  
  private let startLabel = UILabel()
  private let endLabel = UILabel()

  private let startPicker = UIDatePicker()
  private let endPicker = UIDatePicker()

  func setup(dataSource: FSCalendarDataSource) {
    laidOutViews()
    customizeViews()
    
    calendar.dataSource = dataSource
  }
  
  func getChosenDateTimeInterval() -> DateTimeInterval {
    let day = calendar.selectedDate ?? calendar.today ?? Date()    
    return (day, startPicker.date, endPicker.date)
  }
  
  private func laidOutViews() {
    addSubview(calendar)
    
    addSubview(timePickerContainer)

    timePickerContainer.addSubview(startLabel)
    timePickerContainer.addSubview(endLabel)
    
    timePickerContainer.addSubview(startPicker)
    timePickerContainer.addSubview(endPicker)

    calendar.translatesAutoresizingMaskIntoConstraints = false

    timePickerContainer.translatesAutoresizingMaskIntoConstraints = false

    startLabel.translatesAutoresizingMaskIntoConstraints = false
    endLabel.translatesAutoresizingMaskIntoConstraints = false
    
    startPicker.translatesAutoresizingMaskIntoConstraints = false
    endPicker.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: calendar, attribute: .top, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
    NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0).isActive = true
    
    NSLayoutConstraint(item: startLabel, attribute: .top, relatedBy: .equal, toItem: timePickerContainer, attribute: .top, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: startLabel, attribute: .left, relatedBy: .equal, toItem: timePickerContainer, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: startLabel, attribute: .height, relatedBy: .equal, toItem: timePickerContainer, attribute: .height, multiplier: 0.05, constant: 0).isActive = true
    NSLayoutConstraint(item: startLabel, attribute: .width, relatedBy: .equal, toItem: timePickerContainer, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
    
    NSLayoutConstraint(item: endLabel, attribute: .top, relatedBy: .equal, toItem: startLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: endLabel, attribute: .height, relatedBy: .equal, toItem: startLabel, attribute: .height, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: endLabel, attribute: .width, relatedBy: .equal, toItem: startLabel, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: endLabel, attribute: .right, relatedBy: .equal, toItem: timePickerContainer, attribute: .right, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: startPicker, attribute: .top, relatedBy: .equal, toItem: startLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: startPicker, attribute: .left, relatedBy: .equal, toItem: startLabel, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: startPicker, attribute: .width, relatedBy: .equal, toItem: startLabel, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: startPicker, attribute: .bottom, relatedBy: .equal, toItem: timePickerContainer, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: endPicker, attribute: .top, relatedBy: .equal, toItem: endLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: endPicker, attribute: .right, relatedBy: .equal, toItem: endLabel, attribute: .right, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: endPicker, attribute: .width, relatedBy: .equal, toItem: endLabel, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: endPicker, attribute: .bottom, relatedBy: .equal, toItem: timePickerContainer, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint(item: timePickerContainer, attribute: .top, relatedBy: .equal, toItem: calendar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: timePickerContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: timePickerContainer, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: timePickerContainer, attribute: .bottom, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .bottom, multiplier: 0.9, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    startLabel.text = "FROM"
    startLabel.font = startLabel.font.withSize(20)
    startLabel.textAlignment = .center
    startLabel.adjustsFontSizeToFitWidth = true
    startLabel.adjustsFontForContentSizeCategory = true
    
    endLabel.text = "TO"
    endLabel.font = endLabel.font.withSize(20)
    endLabel.textAlignment = .center
    endLabel.adjustsFontSizeToFitWidth = true
    endLabel.adjustsFontForContentSizeCategory = true
    
    startPicker.datePickerMode = .time
    startPicker.minuteInterval = 10
    startPicker.locale = DateManager.shared.getLocale(.hour24)
    startPicker.date = DateManager.shared.stringToDate("05:00", format: .time)
    startPicker.minimumDate = startPicker.date

    endPicker.datePickerMode = .time
    endPicker.locale = DateManager.shared.getLocale(.hour24)
    endPicker.date = DateManager.shared.stringToDate("23:00", format: .time)
    endPicker.maximumDate = endPicker.date
    endPicker.minuteInterval = 10
  }
}
