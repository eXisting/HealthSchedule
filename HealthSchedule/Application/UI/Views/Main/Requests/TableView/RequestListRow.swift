//
//  HistoryRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestListRow: UITableViewCell {
  private let serviceName = UILabel()
  private let price = UILabel()
  private let visitedDate = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutViews()
    customizeViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func populateCell(serviceName: String, price: String, visitedDate: String) {
    self.serviceName.text = serviceName
    self.price.text = price
    self.visitedDate.text = visitedDate
  }
  
  private func laidOutViews() {
    addSubview(serviceName)
    addSubview(price)
    addSubview(visitedDate)
    
    serviceName.translatesAutoresizingMaskIntoConstraints = false
    price.translatesAutoresizingMaskIntoConstraints = false
    visitedDate.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: serviceName, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: serviceName, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.95, constant: 0).isActive = true
    NSLayoutConstraint(item: serviceName, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: serviceName, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
    
    NSLayoutConstraint(item: price, attribute: .top, relatedBy: .equal, toItem: serviceName, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: price, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.47, constant: 0).isActive = true
    NSLayoutConstraint(item: price, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: price, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
    
    NSLayoutConstraint(item: visitedDate, attribute: .top, relatedBy: .equal, toItem: serviceName, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: visitedDate, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.47, constant: 0).isActive = true
    NSLayoutConstraint(item: visitedDate, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: visitedDate, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    serviceName.adjustsFontSizeToFitWidth = true
    price.adjustsFontSizeToFitWidth = true
    visitedDate.adjustsFontSizeToFitWidth = true
    
    price.textAlignment = .center
    visitedDate.textAlignment = .center
    
    accessoryType = .disclosureIndicator
  }
}
