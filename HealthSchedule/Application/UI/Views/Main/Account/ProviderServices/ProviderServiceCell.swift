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
  private let priceLabel = UILabel()
  private let duration = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupData(id: Int, price: Double, duration: Date?) {
    idLabel.text = "ID: \(String(id))"
    priceLabel.text = "Price: \(String(price))"
    self.duration.text = "Duration \(duration != nil ? DateManager.shared.date2String(with: .time, duration!, .hour24) : "no_duration")"
  }
  
  private func laidOutViews() {
    addSubview(container)
    
    addSubview(idLabel)
    container.addArrangedSubview(priceLabel)
    container.addArrangedSubview(duration)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    idLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 0.8, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 0.5, constant: 0).isActive = true
    
    NSLayoutConstraint(item: idLabel, attribute: .left, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: idLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: idLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0).isActive = true
    NSLayoutConstraint(item: idLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 0.95, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    container.alignment = .leading
    container.distribution = .fillEqually
    container.axis = .vertical
  }
}
