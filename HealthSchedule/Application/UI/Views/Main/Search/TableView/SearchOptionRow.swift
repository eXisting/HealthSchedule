//
//  SearchOptionRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchOptionRow: UITableViewCell {
  static let lightOrange = UIColor(red: 255, green: 246, blue: 224)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .disclosureIndicator
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setChosenValue(value: String) {
    self.textLabel?.text?.append(" - (\(value))")
  }
}
