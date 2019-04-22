//
//  HistoryRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/5/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestListRow: UITableViewCell {
  private let statusLabel = UILabel()
  private let serviceName = UILabel()
  private let price = UILabel()
  private let visitedDate = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    laidOutViews()
    customizeViews()
    
    selectionStyle = .none
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func populateCell(serviceName: String, price: String, visitedDate: String, status: RequestStatusName) {
    self.serviceName.text = serviceName
    self.price.text = price
    self.visitedDate.text = visitedDate
    self.statusLabel.text = status.rawValue
    
    status2Color(status)
  }
  
  private func status2Color(_ status: RequestStatusName) {
    var statusColor: UIColor
    
    switch status {
    case .done:
      statusColor = .black
    case .pending:
      statusColor = .blue
    case .rejected:
      statusColor = .red
    case .accepted:
      statusColor = .green
    case .unknown:
      statusColor = .gray
    }
    
    statusLabel.textColor = statusColor
  }
  
  private func laidOutViews() {
    addSubview(serviceName)
    addSubview(price)
    addSubview(visitedDate)
    addSubview(statusLabel)

    serviceName.translatesAutoresizingMaskIntoConstraints = false
    price.translatesAutoresizingMaskIntoConstraints = false
    visitedDate.translatesAutoresizingMaskIntoConstraints = false
    statusLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: serviceName, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.9, constant: 1).isActive = true
    NSLayoutConstraint(item: serviceName, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
    NSLayoutConstraint(item: serviceName, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: serviceName, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0).isActive = true
    
    NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 0.9, constant: 0).isActive = true
    NSLayoutConstraint(item: statusLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.4, constant: 0).isActive = true
    NSLayoutConstraint(item: statusLabel, attribute: .left, relatedBy: .equal, toItem: serviceName, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: statusLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0).isActive = true
    
    NSLayoutConstraint(item: visitedDate, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: visitedDate, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
    NSLayoutConstraint(item: visitedDate, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -8).isActive = true
    NSLayoutConstraint(item: visitedDate, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
    
    NSLayoutConstraint(item: price, attribute: .bottom, relatedBy: .equal, toItem: serviceName, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: price, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.4, constant: 0).isActive = true
    NSLayoutConstraint(item: price, attribute: .right, relatedBy: .equal, toItem: visitedDate, attribute: .right, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: price, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.3, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    serviceName.adjustsFontSizeToFitWidth = true
    price.adjustsFontSizeToFitWidth = true
    visitedDate.adjustsFontSizeToFitWidth = true
    statusLabel.adjustsFontSizeToFitWidth = true
    
    price.textAlignment = .right
    visitedDate.textAlignment = .right
    serviceName.font = UIFont.boldSystemFont(ofSize: 20)
  }
}
