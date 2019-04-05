//
//  ProviderServiceCreateRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServiceCreateRow: UITableViewCell {
  private let container = UIStackView()
  
  private let editableField = IdentifyingTextField()
  private let nameLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(name: String, delegate: UITextFieldDelegate) {
    nameLabel.text = name
    editableField.placeholder = name
    editableField.delegate = delegate
  }
  
  func configureIdentity(identifier: IndexPath, subType: AccountRowSubtype) {
    editableField.identifier = identifier
    editableField.subType = subType
  }
  
  private func laidOutViews() {
    addSubview(container)
    container.addArrangedSubview(nameLabel)
    container.addArrangedSubview(editableField)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    editableField.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: editableField, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 0.7, constant: 0).isActive = true
    
    NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 0.95, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.95, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    container.alignment = .fill
    container.distribution = .fill
    container.axis = .horizontal
    
    editableField.textColor = .black
    editableField.textAlignment = .left
    editableField.adjustsFontSizeToFitWidth = true
    editableField.clearButtonMode = .whileEditing
    
    nameLabel.adjustsFontSizeToFitWidth = true
    
    selectionStyle = .none
  }
}

