//
//  ScheduleModalTableViewRows.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ScheduleModalTableViewDatePickerRow: UITableViewCell {
  private var datePicker = UIDatePicker()
  private var onValueChanged: ((Date, IndexPath) -> Void)?
  
  var identifier: IndexPath?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    
    accessoryType = .none
    selectionStyle = .none
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(identifier: IndexPath, onValueChangedHandler: @escaping (Date, IndexPath) -> Void) {
    addSubview(datePicker)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    
    datePicker.datePickerMode = .time
    datePicker.minuteInterval = 20
    datePicker.locale = DateManager.shared.getLocale(.hour24)
    
    datePicker.pin(to: self)
    
    onValueChanged = onValueChangedHandler
    self.identifier = identifier
  }
  
  func set(dateToDisplay: String, datesRange: (Date, Date)) {
    datePicker.date = DateManager.shared.stringToDate(dateToDisplay, format: .time, .hour24)
    datePicker.minimumDate = datesRange.0
    datePicker.maximumDate = datesRange.1
  }
  
  @objc private func dateChanged(_ sender: UIDatePicker) {
    onValueChanged?(sender.date, identifier!)
  }
}

class ScheduleModalTableViewSelectableRow: UITableViewCell {
  var identifier: IndexPath?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    accessoryType = .none
    selectionStyle = .none
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(_ displayText: String, identifier: IndexPath) {
    textLabel?.text = displayText
    self.identifier = identifier
  }
}
