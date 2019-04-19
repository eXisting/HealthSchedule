//
//  SearchResultView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/18/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy

class SearchResultView: UIView {
  static var cellReuseIdentifier = "DemoFoldingCell"
  static var headerReuseIdentifier = "CommonExpandableSection"

  private let tableView = UITableView()
  private let dismissButton = UIButton()

  var dismissDelegate: DismissableController?
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    
    tableView.delegate = delegate
    tableView.dataSource = dataSource
    
    tableView.register(SearchResultFoldingCell.self, forCellReuseIdentifier: SearchResultView.cellReuseIdentifier)
    tableView.register(CommonExpandableSection.self, forHeaderFooterViewReuseIdentifier: SearchResultView.headerReuseIdentifier)
    
    dismissButton.addTarget(self, action: #selector(onDismissButtonClick), for: .touchDown)
    
    // Remove last underline in table view
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  func reloadSections(_ path: IndexSet, with animation: UITableView.RowAnimation) {
    tableView.reloadSections(path, with: animation)
  }
  
  @objc private func onDismissButtonClick() {
    dismissDelegate?.dismiss()
  }
  
  private func laidOutViews() {
    addSubview(dismissButton)
    addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    dismissButton.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.easy.layout([
      Height(*0.8).like(self),
      Width().like(self),
      CenterX().to(self),
      Top().to(self)
    ])
    
    dismissButton.easy.layout([
      Width(*0.65).like(self),
      CenterX().to(self),
      Top(>=8).to(tableView, .bottom).with(.low),
      Bottom(>=16).to(self).with(.high)
    ])
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    dismissButton.roundBorder()
    dismissButton.setTitle("Close", for: .normal)
    dismissButton.backgroundColor = .clear
    dismissButton.setTitleColor(.black, for: .normal)
    
    tableView.estimatedRowHeight = 0
    tableView.estimatedSectionHeaderHeight = 0
    tableView.estimatedSectionFooterHeight = 0
  }
}
