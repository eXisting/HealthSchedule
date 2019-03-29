//
//  RequestsModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestsModel {
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  let dataSource = RequestsDataSource()
  
  subscript(forRowIndex: Int) -> Request {
    return dataSource.data[forRowIndex]
  }
  
  func loadRequests(_ callback: @escaping (String) -> Void) {
    userRequestController.getRequests {
      [weak self] response in
      guard let requests = DataBaseManager.shared.resultController.fetchedObjects else {
        callback(ResponseStatus.applicationError.rawValue)
        return
      }
      
      self?.dataSource.data = requests
      
      callback(response)
    }
  }
  
  func getStoredRequests(_ callback: @escaping (String) -> Void) {
    guard let requests = DataBaseManager.shared.resultController.fetchedObjects else { return }
    
    dataSource.data = requests
    
    callback(ResponseStatus.success.rawValue)
  }
}

class RequestsDataSource: NSObject, UITableViewDataSource {
  fileprivate var data: [Request] = []
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RequestListTableView.cellIdentifier, for: indexPath) as! RequestListRow
    let request = data[indexPath.row]
    
    cell.populateCell(
      serviceName: request.service?.name ?? "Unkown name",
      price: String(request.providerService?.price ?? 0.0),
      visitedDate: DateManager.shared.dateToString(request.requestedAt),
      status: String(request.status)
    )
    
    return cell
  }
}
