//
//  BaseProfileView.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import EasyPeasy
import Presentr

class ProfileView: UIView {
  private var spinner = UIActivityIndicatorView(style: .whiteLarge)
  private let profileImageView = UIImageView()
  private let tableView = AccountTableView()
  
  let datepickerView = DatePickerView()
  
  lazy var presenter: Presentr = {
    let customType = PresentationType.popup
    
    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .crossDissolve
    customPresenter.dismissTransitionType = .crossDissolve
    customPresenter.roundCorners = true
    customPresenter.backgroundColor = .lightGray
    customPresenter.backgroundOpacity = 0.5
    customPresenter.cornerRadius = 10
    return customPresenter
  }()
  
  func setup(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    laidOutViews()
    customizeViews()
    
    tableView.setup(delegate: delegate, dataSource: dataSource)
    
    toggleSpinner()
  }
  
  func setImage(_ image: UIImage) {
    profileImageView.roundCorners(by: profileImageView.frame.height / 2)

    toggleSpinner()
    
    UIView.transition(with: profileImageView,
                      duration: 0.75,
                      options: .transitionCrossDissolve,
                      animations: { [weak self] in self?.profileImageView.image = image },
                      completion: nil)
  }
  
  func setRefreshDelegate(delegate: RefreshingTableView) {
    tableView.refreshDelegate = delegate
  }
  
  func reloadRows(at indexPath: [IndexPath]) {
    tableView.reloadRows(at: indexPath, with: .fade)
  }
  
  private func laidOutViews() {
    addSubview(profileImageView)
    addSubview(tableView)
    addSubview(spinner)
    
    spinner.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.compatibleSafeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -8).isActive = true
   
    profileImageView.easy.layout([
      CenterX().to(self),
      Height().like(profileImageView, .width).with(.high),
      Width(<=0.2).like(self, .height),
      Height(*0.2).like(self).with(.required)
    ])

    tableView.easy.layout([
      Top(==16).to(profileImageView, .bottom),
      Width().like(self),
      CenterX().to(self)
    ])
    
    spinner.easy.layout([
      CenterX().to(profileImageView, .centerX),
      CenterY().to(profileImageView, .centerY),
      Height().like(profileImageView, .height),
      Width().like(profileImageView, .width)
      ])
  }
  
  private func customizeViews() {
    spinner.color = .black
  }
  
  private func toggleSpinner() {
    if spinner.isAnimating {
      spinner.stopAnimating()
      spinner.removeFromSuperview()
    } else {
      spinner.startAnimating()
    }
  }
}
