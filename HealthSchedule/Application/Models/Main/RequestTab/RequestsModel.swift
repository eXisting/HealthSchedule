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
  
  func loadRequests(_ callback: @escaping (String) -> Void) {
    userRequestController.getRequests(completion: callback)
  }
  
  func getStoredRequests(_ callback: @escaping (String) -> Void) {
    guard let _ = DataBaseManager.shared.requestsResultController.fetchedObjects else { return }
    callback(ResponseStatus.success.rawValue)
  }
}

class RequestsDataSource: NSObject, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return DataBaseManager.shared.requestsResultController.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DataBaseManager.shared.requestsResultController.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RequestListTableView.cellIdentifier, for: indexPath) as! RequestListRow
    let request = DataBaseManager.shared.requestsResultController.object(at: indexPath)
    
    cell.populateCell(
      serviceName: request.service?.name ?? "Unkown name",
      price: String(request.providerService?.price ?? 0.0),
      visitedDate: DateManager.shared.dateToString(request.requestedAt),
      status: request.status2RequestStatusName()
    )
    
    return cell
  }
}
