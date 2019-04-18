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
  private var cellModels: [Int: [ProviderSearchViewModel]] = [:]
  
  private var sendRequestHandler: ((Int, Date) -> Void)!
  
  init(dataModels: [ResultSectionModel], sendRequestHandler: @escaping (Int, Date) -> Void) {
    data = dataModels
    self.sendRequestHandler = sendRequestHandler
    
    for index in 0..<data.count {
      cellModels[index] = [ProviderSearchViewModel].init(repeating: ProviderSearchViewModel(), count: data[index].numberOfRows)
    }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultView.cellReuseIdentifier, for: indexPath) as! SearchResultFoldingCell
    
    let cellModel = cellModels[indexPath.section]![indexPath.row]
    cell.setupCollapsedView(delegate: cellModel.dataSource, dataSource: cellModel.dataSource, identifier: indexPath, onRequestClick: onSendRequest)
    //cell.textLabel?.text = DateManager.shared.date2String(with: .time, data[indexPath.section].rows[indexPath.row].time, .hour24)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! SearchResultFoldingCell
    
    var duration = 0.0
    if data[indexPath.section].rows[indexPath.row].rowHeight == cell.collapsedHeight { // open cell
      data[indexPath.section].rows[indexPath.row].changeHeight(to: cell.maxHeight)
      cell.unfold(true, animated: true, completion: nil)
      
      let cellModel = cellModels[indexPath.section]![indexPath.row]
      
      cellModel.setupProviderCard(with: data[indexPath.section].rows[indexPath.row].userIds.first!)
      
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
  
  private func onSendRequest(_ identity: IndexPath) {
    let providerId = data[identity.section].rows[identity.row].userIds.first!
    let choosenTime = data[identity.section].rows[identity.row].time
    let chosenDate = DateManager.shared.stringToDate(data[identity.section].sectionName, format: .date)
    
    guard let bookingTime = DateManager.shared.combineDateWithTime(date: chosenDate, time: choosenTime) else {
      fatalError()
    }
    
    sendRequestHandler(providerId, bookingTime)
  }
}

