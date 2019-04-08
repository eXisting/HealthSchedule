//
//  View.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ScheduleEventModalView: UIView {
  private let container = UIStackView()
  
  let tableView = ScheduleEventTableView()
  
  private var actionsBlock: UIStackView?
  private let actionsBackground = UIView()
  private var declineButton: UIButton?
  private var acceptButton: UIButton?
  
  private var onAcceptClickHandler: (() -> Void)?
  private var onDeclineClickHandler: (() -> Void)?
  
  func setup(acceptHandler: @escaping () -> Void, declineHandler: @escaping () -> Void) {
    buildHierachy()
    customizeViews()
    
    onAcceptClickHandler = acceptHandler
    onDeclineClickHandler = declineHandler
    addTargets()
  }
  
  func addBordersTosButtons() {
    actionsBlock?.addBorder(side: .top, thickness: 1, color: .lightGray)
    declineButton?.addBorder(side: .right, thickness: 0.5, color: .lightGray)
    acceptButton?.addBorder(side: .left, thickness: 0.5, color: .lightGray)
  }

  private func addTargets() {
    declineButton?.addTarget(self, action: #selector(onDeclineClick), for: .touchUpInside)
    acceptButton?.addTarget(self, action: #selector(onAcceptClick), for: .touchUpInside)
  }
  
  @objc private func onAcceptClick() {
    onAcceptClickHandler?()
  }
  
  @objc private func onDeclineClick() {
    onDeclineClickHandler?()
  }
  
  private func buildHierachy() {
    addSubview(container)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    container.pin(to: self)
    
    container.addArrangedSubview(tableView)
    
    actionsBlock = UIStackView()
    container.addArrangedSubview(actionsBlock!)
    
    declineButton = UIButton(type: UIButton.ButtonType.roundedRect)
    actionsBlock!.addArrangedSubview(declineButton!)
    
    acceptButton = UIButton(type: UIButton.ButtonType.roundedRect)
    actionsBlock!.addArrangedSubview(acceptButton!)
    
    actionsBackground.backgroundColor = .white
    actionsBlock?.addBackgroundView(actionsBackground)
    
    NSLayoutConstraint(
      item: tableView,
      attribute: .height,
      relatedBy: .equal,
      toItem: container,
      attribute: .height,
      multiplier: 0.85,
      constant: 0).isActive = true
    
    NSLayoutConstraint(
      item: tableView,
      attribute: .width,
      relatedBy: .equal,
      toItem: container,
      attribute: .width,
      multiplier: 1,
      constant: 0).isActive = true
    
    NSLayoutConstraint(
      item: actionsBlock!,
      attribute: .width,
      relatedBy: .equal,
      toItem: container,
      attribute: .width,
      multiplier: 1,
      constant: 0).isActive = true

    NSLayoutConstraint(
      item: actionsBlock!,
      attribute: .height,
      relatedBy: .equal,
      toItem: container,
      attribute: .height,
      multiplier: 0.1,
      constant: 0).isActive = true
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    container.axis = .vertical
    container.distribution = .equalSpacing
    container.alignment = .top
    
    actionsBlock?.axis = .horizontal
    actionsBlock?.distribution = .fillEqually
    actionsBlock?.alignment = .fill
    
    acceptButton?.setTitle("SAVE", for: .normal)
    declineButton?.setTitle("CANCEL", for: .normal)
    
    acceptButton?.setTitleColor(.blue, for: .normal)
    declineButton?.setTitleColor(.blue, for: .normal)
  }
}
