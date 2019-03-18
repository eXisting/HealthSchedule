//
//  SearchResultView.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/18/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchResultView: UIView {
  var dismissDelegate: DismissableController?

  private let dismissButton = UIButton()
  
  func setup() {//delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    
    dismissButton.addTarget(self, action: #selector(onDismissButtonClick), for: .touchDown)
  }
  
  @objc private func onDismissButtonClick() {
    dismissDelegate?.dismiss()
  }
  
  private func laidOutViews() {
    addSubview(dismissButton)
    
    dismissButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: dismissButton, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 8).isActive = true
    NSLayoutConstraint(item: dismissButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.65, constant: 0).isActive = true
    NSLayoutConstraint(item: dismissButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    backgroundColor = .white
    
    dismissButton.roundBorder()
    dismissButton.setTitle("Close", for: .normal)
    dismissButton.backgroundColor = .clear
    dismissButton.setTitleColor(.black, for: .normal)
  }
}
