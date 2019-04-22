//
//  CardContainerView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardContainerView: UIView {
  private let container = UIStackView()
  
  let tableView = RequestCardTableView()
  
  private var actionsBlock: UIStackView?
  private let actionsBackground = UIView()
  private var declineButton: UIButton?
  private var acceptButton: UIButton?
  
  private var onAcceptClickHandler: (() -> Void)?
  private var onDeclineClickHandler: (() -> Void)?

  func setup(actionsCount: Int, role: Role) {
    buildHierachy(actionsCount, role)
    customizeViews()
  }
  
  func setup(acceptHandler: @escaping () -> Void, declineHandler: @escaping () -> Void) {
    onAcceptClickHandler = acceptHandler
    onDeclineClickHandler = declineHandler
    addTargets()
  }
  
  private func addTargets() {
    declineButton?.addTarget(self, action: #selector(onDeclineClick), for: .touchUpInside)
    acceptButton?.addTarget(self, action: #selector(onAcceptClick), for: .touchUpInside)
  }
  
  func laidOutViews() {
    actionsBackground.addBorder(side: .top, thickness: 0.5, color: .lightGray)
  }
  
  @objc private func onAcceptClick() {
    onAcceptClickHandler?()
  }
  
  @objc private func onDeclineClick() {
    onDeclineClickHandler?()
  }

  private func buildHierachy(_ actionsCount: Int, _ role: Role) {
    addSubview(container)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    container.pin(to: self)

    container.addArrangedSubview(tableView)
    
    if actionsCount > 0 {
      actionsBlock = UIStackView()
      container.addArrangedSubview(actionsBlock!)
      
      declineButton = UIButton(type: UIButton.ButtonType.roundedRect)
      actionsBlock!.addArrangedSubview(declineButton!)
      
      if actionsCount > 1 {
        processUserType(role)
      }
      
      actionsBackground.backgroundColor = .white
      actionsBlock?.addBackgroundView(actionsBackground)
      
      NSLayoutConstraint(
        item: actionsBlock!,
        attribute: .height,
        relatedBy: .equal,
        toItem: container,
        attribute: .height,
        multiplier: 0.1,
        constant: 0).isActive = true
    }
  }
  
  private func customizeViews() {
    container.axis = .vertical
    container.distribution = .fill
    container.alignment = .fill
    
    actionsBlock?.axis = .horizontal
    actionsBlock?.distribution = .fillEqually
    actionsBlock?.alignment = .fill
    
    acceptButton?.setTitle("ACCEPT", for: .normal)
    declineButton?.setTitle("DECLINE", for: .normal)
    
    acceptButton?.setTitleColor(.blue, for: .normal)
    declineButton?.setTitleColor(.black, for: .normal)
  }
  
  private func processUserType(_ role: Role) {
    if role.role2UserTypeName() == .provider {
      acceptButton = UIButton(type: UIButton.ButtonType.roundedRect)
      actionsBlock!.addArrangedSubview(acceptButton!)
    }
  }
}
