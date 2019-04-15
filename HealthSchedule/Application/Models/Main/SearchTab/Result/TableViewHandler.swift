//
//  SearchResultDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FoldingCell

class ResultsTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
  private var data: [ResultSectionModel] = []
    
  init(dataModels: [ResultSectionModel]) {
    data = dataModels
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return data[section].sectionHeight
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].numberOfRows
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return data[indexPath.section].rows[indexPath.row].rowHeight
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return data[section].sectionName
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultView.cellReuseIdentifier, for: indexPath)
    
    //cell.textLabel?.text = DateManager.shared.date2String(with: .time, data[indexPath.section].rows[indexPath.row].time, .hour24)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! SearchResultFoldingCell
    
    var duration = 0.0
    if data[indexPath.section].rows[indexPath.row].rowHeight == cell.collapsedHeight { // open cell
      data[indexPath.section].rows[indexPath.row].changeHeight(to: cell.maxHeight)
      cell.unfold(true, animated: true, completion: nil)
      duration = 0.5
    } else { // close cell
      data[indexPath.section].rows[indexPath.row].changeHeight(to: cell.collapsedHeight)
      cell.unfold(false, animated: true, completion: nil)
      duration = 1.1
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let cell = cell as! SearchResultFoldingCell
    
    if data[indexPath.section].rows[indexPath.row].rowHeight == cell.collapsedHeight {
      cell.unfold(false, animated: false, completion:nil)
    } else {
      cell.unfold(true, animated: false, completion: nil)
    }
  }
}

