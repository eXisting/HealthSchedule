//
//  DatePickerView.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
  private weak var target: UITextField?
  
  private var datePicker: UIDatePicker!
  private var datesRange: (min: Date, max: Date)?
  
  private var toolbar: UIToolbar!
  
  private var doneButton: UIBarButtonItem!
  private var spaceButton: UIBarButtonItem!
  private var cancelButton: UIBarButtonItem!

  func setup(target: UITextField, shouldAddTarget: Bool = true, isBirthdayPicker: Bool = false) {
    datePicker = UIDatePicker()
    
    self.target = target
    datePicker.datePickerMode = .date
    
    if isBirthdayPicker {
      datesRange = DateManager.shared.getAvailableBirthdayRange()
      datePicker.maximumDate = datesRange?.max
      datePicker.minimumDate = datesRange?.min
    }
    
    toolbar = UIToolbar()
    toolbar!.sizeToFit()
    
    doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onDoneClick));
    spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onCancelClick));
    
    if shouldAddTarget {
      target.addTarget(self, action: #selector(showDatePicker), for: .touchDown)
    }
  }
  
  func setCustomPickerMode(mode: UIDatePicker.Mode, interval: Int) {
    datePicker.datePickerMode = mode
    datePicker.minuteInterval = interval
    
    if mode == .time {      
      datePicker.locale = DateManager.shared.getLocale(.hour24)
    }    
  }
  
  func setupInitialTime(data: String?) {
    if let data = data {
      datePicker.date = DateManager.shared.stringToDate(data, format: .time, .hour24)      
    }
  }
  
  @objc func showDatePicker() {
    target?.inputView = datePicker
    target?.inputAccessoryView = toolbar
    target?.inputView = datePicker
    
    toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
  }
  
  @objc func onDoneClick(){
    if datePicker.datePickerMode == .time {
      target?.text = DateManager.shared.date2String(with: .time, datePicker.date, .hour24)
    } else {
      target?.text = DateManager.shared.dateToString(datePicker.date)
    }
    
    target?.endEditing(true)
  }
  
  @objc func onCancelClick(){
    target?.endEditing(true)
  }
}
