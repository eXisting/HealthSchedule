//
//  SearchDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/22/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchDataSource: NSObject, UITableViewDataSource {
  enum SectionsIndexes: Int {
    case searchOptions = 0; case chosenOptions = 1
  }
  
  // note: order is important
  enum ChosenOptionsRows: Int {
    case service = 0; case city = 1; case range = 2
  }
  
  var sectionsData: [[Any]] = [
    [SearchOptionKey.service, SearchOptionKey.dateTime],
    ["", "", ""]
  ]
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionsData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == SectionsIndexes.chosenOptions.rawValue {
      var rowsActualCount = sectionsData[section].count

      sectionsData[section].forEach({ element in
        if (element as! String).isEmpty {
          rowsActualCount -= 1
        }
      })

      return rowsActualCount
    }
    
    return sectionsData[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == SectionsIndexes.chosenOptions.rawValue {
      let defaultCell = UITableViewCell()
      
      var value = (sectionsData[indexPath.section][indexPath.row] as! String)
      if value.isEmpty {
        value = (sectionsData[indexPath.section][ChosenOptionsRows.range.rawValue] as! String)
      }
      
      defaultCell.textLabel?.text = value
      defaultCell.selectionStyle = .none
      return defaultCell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableView.cellIdentifier, for: indexPath)
    cell.textLabel?.text = (sectionsData[indexPath.section][indexPath.row] as! SearchOptionKey).rawValue
    cell.selectionStyle = .none
    return cell
  }
}
