//
//  SearchOptionRow.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/13/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchOptionRow: UITableViewCell {
  // TODO: RemoteService object
  
  func setChosenValue(value: String) {
    self.textLabel?.text?.append(" - (\(value))")
  }
}
