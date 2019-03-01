//
//  BaseProfileView.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProfileView: UIView {
  
  private let profileImageView = UIImageView()
  
  private let tableView = UITableView()
  
  private let fullNameField = UITextField()
  private let cityField = UITextField()
  private let birthday = UITextField()
  
  func setup() {
    laidOutViews()
    customizeViews()
  }
  
  func populateFields(with userData: User?) {
    guard let user = userData else {
      print("Nothing has been sent from server")
      return
    }
    
    fullNameField.text = user.firstName + " " + user.lastName
    cityField.text = user.city?.name
    birthday.text = DateManager.shared.dateToString(user.birthday)
  }
  
  func setEditingStateTo(_ state: Bool) {
    fullNameField.isUserInteractionEnabled = state
    cityField.isUserInteractionEnabled = state
    birthday.isUserInteractionEnabled = state
  }
  
  private func laidOutViews() {
    addSubview(profileImageView)
    addSubview(tableView)
    
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: profileImageView, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 16).isActive = true
    NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: profileImageView, attribute: .width, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 0.2, constant: 0).isActive = true

    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: profileImageView, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
  }
  
  private func customizeViews() {
    profileImageView.image = UIImage(named: "Pictures/chooseProfile")
  }
}
