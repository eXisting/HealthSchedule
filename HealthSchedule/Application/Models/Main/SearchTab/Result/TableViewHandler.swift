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
  static var container: RemoteAvailableTimeContainer!
  
  private let closeHeight: CGFloat = 90
  private let openHeight: CGFloat = 166
  private var itemHeight = [CGFloat](repeating: 91.0, count: 20)
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return ResultsTableViewHandler.container.data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ResultsTableViewHandler.container.data[section].1.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return DateManager.shared.date2String(with: .date, ResultsTableViewHandler.container.data[section].0)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultView.cellReuseIdentifier, for: indexPath)
    
    cell.textLabel?.text = DateManager.shared.date2String(with: .time, ResultsTableViewHandler.container.data[indexPath.section].1[indexPath.row].0, .hour24)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
    
    var duration = 0.0
    if itemHeight[indexPath.row] == closeHeight { // open cell
      itemHeight[indexPath.row] = openHeight
      cell.unfold(true, animated: true, completion: nil)
      duration = 0.5
    } else { // close cell
      itemHeight[indexPath.row] = closeHeight
      cell.unfold(false, animated: true, completion: nil)
      duration = 1.1
    }
    
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let cell = cell as! FoldingCell
    
//    if itemHeight[indexPath.row] == closeHeight {
      cell.unfold(false, animated: false, completion:nil)
//    } else {
//      cell.unfold(true, animated: false, completion: nil)
//    }
  }
}

