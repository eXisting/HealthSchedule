//
//  SendRequestView.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy

class SendRequestView: UIView {
  private let tableView = UITableView()
  private let actionButton = UIButton(type: .roundedRect)
  
  private var actionHandle: (() -> Void)!
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, action: @escaping () -> Void) {
    laidOutViews()
    customizeViews()
    
    actionHandle = action
    
    tableView.delegate = delegate
    tableView.dataSource = dataSource
    
    tableView.alwaysBounceVertical = false
    tableView.showsVerticalScrollIndicator = true
    
    actionButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
  }
  
  @objc private func handleClick() {
    actionHandle()
  }
  
  private func laidOutViews() {
    addSubview(actionButton)
    addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.easy.layout([
      Top(==16).to(self),
      Height(*0.7).like(self),
      Width().like(self),
      CenterX().to(self)
    ])
    
    actionButton.easy.layout([
      Height(*0.1).like(self),
      Width(*0.75).like(self),
      CenterX().to(self),
      Bottom(==16).to(self),
      Top(>=0).to(tableView, .bottom).with(.low)
    ])
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    actionButton.roundBorder()
    actionButton.setTitle("BOOK", for: .normal)
    actionButton.backgroundColor = .clear
    actionButton.setTitleColor(.black, for: .normal)
  }
}
