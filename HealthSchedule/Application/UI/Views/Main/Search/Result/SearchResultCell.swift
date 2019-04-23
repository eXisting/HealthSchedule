//
//  SearchResultCelll.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FoldingCell
import EasyPeasy

class SearchResultFoldingCell: FoldingCell {
  private let displayLabel = UILabel()
  
  let maxHeight: CGFloat = 400
  let collapsedHeight: CGFloat = 70
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    containerView = createContainerView()
    foregroundView = createForegroundView()
    
    setupDisplayLabel()
    
    itemCount = 3 // used for calculation of the height
    
    // super class method configure views
    commonInit()
    
    self.clipsToBounds = true
  }
  
  func setupCollapsedView(
    delegate: UITableViewDelegate,
    dataSource: UITableViewDataSource,
    identifier: IndexPath,
    onRequestClick: @escaping (IndexPath) -> Void) {
    let providerView = (containerView as! SearchElementProviderView)
    providerView.setup(identity: identifier, action: onRequestClick)
    providerView.setupTableView(delegate: delegate, dataSource: dataSource)
  }
  
  func setupDisplayTime(_ text: String) {
    displayLabel.text = text
  }
  
  func reloadTableView() {
    let providerView = (containerView as! SearchElementProviderView)
    providerView.reloadData()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
    return 0.005 // timing animation for each view
  }
}

// MARK: Configure
extension SearchResultFoldingCell {
  
  private func createForegroundView() -> RotatedView {
    let foregroundView = Init(value: RotatedView(frame: .zero)) {
      $0.backgroundColor = UIColor.init(red:0.87, green:1.00, blue:0.84, alpha:1.0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    contentView.addSubview(foregroundView)
    
    foregroundView.easy.layout([
      Height(collapsedHeight), //padding
      Left(8),
      Right(8)
    ])
    
    // add identifier
    let top = foregroundView.easy.layout([Top(8)]).first
    top?.identifier = "ForegroundViewTop"
    
    foregroundViewTop = top
    
    foregroundView.layoutIfNeeded()
    
    return foregroundView
  }
  
  private func createContainerView() -> SearchElementProviderView {
    let containerView = Init(value: SearchElementProviderView(frame: .zero)) {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    contentView.addSubview(containerView)
    
    // add constraints
    containerView.easy.layout([
      Height(maxHeight),
      Left(8),
      Right(8)
    ])
    
    // add identifier
    let top = containerView.easy.layout([Top(8)]).first
    top?.identifier = "ContainerViewTop"
    
    containerViewTop = top
    
    containerView.layoutIfNeeded()
    
    return containerView
  }
  
  private func setupDisplayLabel() {
    displayLabel.translatesAutoresizingMaskIntoConstraints = false
    foregroundView.addSubview(displayLabel)
    displayLabel.pin(to: foregroundView)
  }
}
