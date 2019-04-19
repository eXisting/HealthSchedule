//
//  SearchElementProviderView.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy

class SearchElementProviderView: UIView {
  private let tableView = UITableView()
  private let actionButton = UIButton()
  
  private var onButtonClickAction: ((IndexPath) -> Void)?
  
  var identifier: IndexPath!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    laidOutViews()
    customizeViews()
    
    tableView.isUserInteractionEnabled = false
    actionButton.isUserInteractionEnabled = true
    
    tableView.register(RequestCardImageRow.self, forCellReuseIdentifier: "RequestCardImageRow")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    tableView.delegate = delegate
    tableView.dataSource = dataSource
  }
  
  func setup(identity: IndexPath, action: @escaping (IndexPath) -> Void) {
    identifier = identity
    onButtonClickAction = action
    actionButton.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
  }
  
  func reloadData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  @objc private func onButtonClick() {
    onButtonClickAction?(identifier)
  }
  
  private func laidOutViews() {
    addSubview(tableView)
    addSubview(actionButton)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.easy.layout([
      Top().to(self),
      CenterX().to(self),
      Width().like(self),
      Height(*0.8).like(self)
    ])
    
    actionButton.easy.layout([
      Top(16).to(tableView, .bottom).with(.required),
      Width(*0.65).like(self),
      CenterX().to(self),
      Bottom(>=16).to(self)
    ])
  }
  
  private func customizeViews() {
    tableView.backgroundColor = UIColor(red: 213, green: 235, blue: 235)
    backgroundColor = UIColor(red: 213, green: 235, blue: 235)
    
    actionButton.roundBorder()
    actionButton.setTitle("SEND REQUEST", for: .normal)
    actionButton.backgroundColor = .clear
    actionButton.setTitleColor(.black, for: .normal)
  }
}
