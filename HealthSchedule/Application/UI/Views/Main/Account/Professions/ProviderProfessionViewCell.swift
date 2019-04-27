//
//  ProfessionViewCell.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderProfessionViewCell: UITableViewCell {
  private let container = UIStackView()
  
  private let idLabel = UILabel()
  private let cityLabel = UILabel()
  private let companyLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .disclosureIndicator
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupData(id: Int, city: String, company: String) {
    idLabel.text = "ID: \(id)"
    cityLabel.text = "City: \(city)"
    companyLabel.text = "Company \(company)"
  }
  
  private func laidOutViews() {
    addSubview(container)
    
    container.addArrangedSubview(idLabel)
    container.addArrangedSubview(cityLabel)
    container.addArrangedSubview(companyLabel)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    idLabel.translatesAutoresizingMaskIntoConstraints = false
    
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

