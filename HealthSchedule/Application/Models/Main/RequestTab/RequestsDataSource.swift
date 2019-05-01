//
//  RequestsDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestsDataSource: NSObject, UITableViewDataSource {
  var deleteHandler: ((Int, @escaping (Bool) -> Void) -> Void)!
  var loaderHandler: LoaderShowable!
  
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
    if editingStyle == .delete {
      loaderHandler.showLoader()
      
      let request = DataBaseManager.shared.requestsResultController.object(at: indexPath)
      deleteHandler(Int(request.id)) { [weak self] isSuccess in
        if isSuccess {
          DataBaseManager.shared.delete(with: request.objectID)
        }
        
        self?.loaderHandler.hideLoader()
      }
    }
  }
}
