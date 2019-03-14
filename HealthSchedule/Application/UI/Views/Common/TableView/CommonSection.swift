//
//  AccountSection.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class CommonSection: UITableViewHeaderFooterView {
  static let lightSectionColor = UIColor.gray.withAlphaComponent(0.005)
  
  func setup(title: String, backgroundColor: UIColor) {
    contentView.backgroundColor = backgroundColor
    textLabel?.text = title
    textLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
  }
}
