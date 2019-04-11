//
//  AccountCommonRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountPlacemarkCell: UITableViewCell {
  private let placemark = UILabel()
  private let editableField = IdentifyingTextField()
  private var datePicker: DatePickerView?
  
  func configureCell(key: String, value: String?, fieldSubtype: AccountRowSubtype, delegate: UITextFieldDelegate) {
    placemark.text = key
    editableField.placeholder = key
    editableField.text = value
    editableField.delegate = delegate
    editableField.subType = fieldSubtype
    
    if editableField.subType == .datePicker {
      datePicker = DatePickerView()
      datePicker?.setup(target: editableField, shouldAddTarget: false, isBirthdayPicker: true)
      datePicker?.setupInitialTime(data: editableField.text)
      editableField.aciton = datePicker?.showDatePicker
    }
  }
  
  func configureIdentity(identifier: IndexPath, subType: AccountRowSubtype) {
    editableField.identifier = identifier
    editableField.subType = subType
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUserInteraction(_ value: Bool) {
    editableField.isUserInteractionEnabled = value
  }
  
  private func laidOutViews() {
    addSubview(editableField)
    addSubview(placemark)
    
    placemark.translatesAutoresizingMaskIntoConstraints = false
    editableField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: editableField, attribute: .bottom, relatedBy: .equal, toItem: placemark, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: editableField, attribute: .top, relatedBy: .equal, toItem: placemark, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: editableField, attribute: .left, relatedBy: .equal, toItem: placemark, attribute: .right, multiplier: 1, constant: -16).isActive = true
    NSLayoutConstraint(item: editableField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
    
    NSLayoutConstraint(item: placemark, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: placemark, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: placemark, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: placemark, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.25, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    editableField.textColor = .black
    editableField.textAlignment = .left
    editableField.adjustsFontSizeToFitWidth = true
    editableField.clearButtonMode = .whileEditing
  }
}
