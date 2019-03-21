//
//  RequestsModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestsModel: NSObject, UITableViewDataSource {
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  private var data: [RemoteRequest] = []
  
  subscript(forSectionIndex: Int) -> RemoteRequest {
    return data[forSectionIndex]
  }
  
  func loadRequests(_ callback: @escaping () -> Void) {
    userRequestController.getRequests {
      [weak self] list in
      self?.data = list
      callback()
    }
  }
  
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
      serviceName: request.providerService.service.title,
      price: String(request.providerService.price),
      visitedDate: DateManager.shared.dateToString(request.requestAt),
      status: request.status.title
    )
    
    return cell
  }
}
