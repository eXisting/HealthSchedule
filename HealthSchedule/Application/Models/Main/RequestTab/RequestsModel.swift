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
  private let source = RequestsDataSource()
  
  var errorHandling: ErrorShowable! {
    didSet { source.deleteHandler = deleteRequest }
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

extension RequestsModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
