//
//  SearchDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/22/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchDataSource: NSObject, UITableViewDataSource {
  let searchOptions = [
    SearchOptionKey.service,
    SearchOptionKey.dateTime
  ]
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchOptions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableView.cellIdentifier, for: indexPath)
    cell.textLabel?.text = searchOptions[indexPath.row].rawValue
    cell.selectionStyle = .none
    return cell
  }
}
