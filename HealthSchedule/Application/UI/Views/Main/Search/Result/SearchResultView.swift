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
  static var cellReuseIdentifier = "FoldingCell"
  static var headerReuseIdentifier = "CommonExpandableSection"
  
  private let headerTitle = UILabel()
  private let headerView = NavigationHoverHeaderView()
  
  private let tableView = UITableView()
  private let dismissButton = UIButton(type: UIButton.ButtonType.roundedRect)

  var dismissDelegate: DismissableController?
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    headerView.setup()
    
    laidOutViews()
    customizeViews()
    
    tableView.delegate = delegate
    tableView.dataSource = dataSource
    
    tableView.register(SearchResultFoldingCell.self, forCellReuseIdentifier: SearchResultView.cellReuseIdentifier)
    tableView.register(CommonExpandableSection.self, forHeaderFooterViewReuseIdentifier: SearchResultView.headerReuseIdentifier)
    
    dismissButton.addTarget(self, action: #selector(onDismissButtonClick), for: .touchUpInside)
    
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
    addSubview(headerView)
    addSubview(dismissButton)
    addSubview(tableView)
    
    headerView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    dismissButton.translatesAutoresizingMaskIntoConstraints = false
    
    headerView.easy.layout([
      Height(*0.1).like(self),
      Width().like(self),
      CenterX().to(self),
      Top().to(self)
    ])
    
    tableView.easy.layout([
      Width().like(self),
      CenterX().to(self),
      Top().to(headerView, .bottom),
      Bottom(==16).to(dismissButton, .top)
    ])
    
    dismissButton.easy.layout([
      Width(*0.65).like(self),
      CenterX().to(self),
      Height(*0.08).like(self),
      Bottom(>=16).to(self)
    ])
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    dismissButton.roundBorder()
    dismissButton.setTitle("CLOSE", for: .normal)
    dismissButton.backgroundColor = .clear
    dismissButton.setTitleColor(.black, for: .normal)
    
    tableView.estimatedRowHeight = 0
    tableView.estimatedSectionHeaderHeight = 0
    tableView.estimatedSectionFooterHeight = 0
  }
}
