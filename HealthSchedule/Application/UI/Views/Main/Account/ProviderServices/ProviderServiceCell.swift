//
//  ProviderServiceCell.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServiceCell: UITableViewCell {
  private let container = UIStackView()
  
  private let idLabel = UILabel()
  private let nameLabel = UILabel()
  private let priceLabel = UILabel()
  private let duration = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .disclosureIndicator
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupData(id: Int, price: Double, name: String, duration: Date?) {
    idLabel.text = "ID: \(id)"
    nameLabel.text = "Name: \(name)"
    priceLabel.text = "Price: \(price)"
    self.duration.text = "Duration \(duration != nil ? DateManager.shared.date2String(with: .time, duration!, .hour24) : "unknown duration")"
  }
  
  private func laidOutViews() {
    addSubview(container)
    
    container.addArrangedSubview(idLabel)
    container.addArrangedSubview(priceLabel)
    container.addArrangedSubview(duration)
    container.addArrangedSubview(nameLabel)

    container.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 16).isActive = true
  }
  
  private func customizeViews() {
    container.alignment = .leading
    container.distribution = .fillEqually
    container.axis = .vertical
    
    idLabel.textColor = .orange
  }
}
