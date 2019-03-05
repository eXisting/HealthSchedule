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

  func setup(target: UITextField, isBirthdayPicker: Bool = false) {
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
    
    target.addTarget(self, action: #selector(showDatePicker), for: .touchDown)
  }
  
  @objc func showDatePicker() {
    target?.inputView = datePicker
    target?.inputAccessoryView = toolbar
    target?.inputView = datePicker
    
    toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
  }
  
  @objc func onDoneClick(){
    target?.text = DateManager.shared.dateToString(datePicker!.date)
    target?.endEditing(true)
  }
  
  @objc func onCancelClick(){
    target?.endEditing(true)
  }
}
