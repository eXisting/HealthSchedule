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
  private var datePicker: UIDatePicker?
  
  func setup(target: UITextField) {
    self.target = target
    target.addTarget(self, action: #selector(showDatePicker), for: .touchDown)
  }
  
  @objc func showDatePicker() {
    if datePicker != nil {
      target?.inputView = datePicker
      return
    }
    
    datePicker = UIDatePicker()
    datePicker!.datePickerMode = .date
    
    let datesRange = DateManager.shared.getAvailableDateRange()
    datePicker?.maximumDate = datesRange.max
    datePicker?.minimumDate = datesRange.min
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
    
    toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    
    target?.inputAccessoryView = toolbar
    target?.inputView = datePicker
  }
  
  @objc func donedatePicker(){
    target?.text = DateManager.shared.dateToString(datePicker!.date)
    target?.endEditing(true)
  }
  
  @objc func cancelDatePicker(){
    target?.endEditing(true)
  }
}
