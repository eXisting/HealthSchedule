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

  func setup(hasActions: Bool, userType: UserType) {
    buildHierachy(hasActions, userType)
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
    actionsBackground.addBorder(side: .top, thickness: 1, color: .lightGray)
    actionsBackground.addBorder(side: .bottom, thickness: 1, color: .lightGray)
  }
  
  @objc private func onAcceptClick() {
    onAcceptClickHandler?()
  }
  
  @objc private func onDeclineClick() {
    onDeclineClickHandler?()
  }

  private func buildHierachy(_ hasActions: Bool, _ userType: UserType) {
    addSubview(container)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    container.pin(to: self)

    container.addArrangedSubview(tableView)
    
    if hasActions {
      actionsBlock = UIStackView()
      container.addArrangedSubview(actionsBlock!)
      
      declineButton = UIButton(type: UIButton.ButtonType.roundedRect)
      actionsBlock!.addArrangedSubview(declineButton!)
      
      processUserType(userType)
      
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
    
    acceptButton?.setTitle("Accept", for: .normal)
    declineButton?.setTitle("Decline", for: .normal)
    
    acceptButton?.setTitleColor(.black, for: .normal)
    declineButton?.setTitleColor(.black, for: .normal)
  }
  
  private func processUserType(_ userType: UserType) {
    if userType == .provider {
      acceptButton = UIButton(type: UIButton.ButtonType.roundedRect)
      actionsBlock!.addArrangedSubview(acceptButton!)
    }
  }
}
