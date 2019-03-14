//
//  AccountRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum AccountCellType {
  case common
  case disclosure
}

class AccountRow: UITableViewCell {
  var value: String? {
    get {
      return editableField.text
    }
    set {
      editableField.text = newValue
    }
  }
  
  private let editableField = UITextField()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func laidOutViews() {
    addSubview(editableField)
    editableField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: editableField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: editableField, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: editableField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
    NSLayoutConstraint(item: editableField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    editableField.textColor = .black
    editableField.textAlignment = .left
    editableField.adjustsFontSizeToFitWidth = true
    editableField.clearButtonMode = .whileEditing
  }
}
