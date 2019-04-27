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
  
  var errorHandling: ErrorShowable! {
    didSet { dataSource.deleteHandler = deleteRequest }
  }
  
  func prefetch() {
    do {
      try DataBaseManager.shared.requestsResultController.performFetch()
    }
    catch { print(error.localizedDescription) }
  }
  
  func loadRequests(_ callback: @escaping (String) -> Void) {
    userRequestController.getRequests { response in
      do {
        try DataBaseManager.shared.requestsResultController.performFetch()
        callback(response)
      }
      catch { callback(error.localizedDescription) }
    }
  }
  
  private func deleteRequest(_ id: Int, _ completion: @escaping (Bool) -> Void) {
    (userRequestController as! UserDataUpdating).deleteRequest(id: id) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        self?.errorHandling.showWarningAlert(message: "Request has not been deleted! Contact the developer!")
        completion(false)
        return
      }
      
      completion(true)
    }
  }
}

class RequestsDataSource: NSObject, UITableViewDataSource {
  fileprivate var deleteHandler: ((Int, @escaping (Bool) -> Void) -> Void)!
  
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
      serviceName: request.providerService?.name ?? request.service?.name ?? "Unkown name",
      price: String(request.providerService?.price ?? 0.0),
      visitedDate: DateManager.shared.dateToString(request.requestedAt),
      status: request.status2RequestStatusName()
    )
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let request = DataBaseManager.shared.requestsResultController.object(at: indexPath)
    
    if editingStyle == .delete {
      deleteHandler(Int(request.id)) { isSuccess in
        if isSuccess {
          DataBaseManager.shared.delete(with: request.objectID)          
        }
      }
    }
  }
}
