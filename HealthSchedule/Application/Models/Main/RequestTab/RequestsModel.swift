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
  
  private var errorHandling: ErrorShowable
  
  init(errorDelegate: ErrorShowable, loaderDelegate: LoaderShowable) {
    errorHandling = errorDelegate
    
    source.loaderHandler = loaderDelegate
    source.deleteHandler = deleteRequest
  }
  
  func reFetch(_ completion: @escaping (String) -> Void) {
    do {
      try DataBaseManager.shared.requestsResultController.performFetch()
      completion(ResponseStatus.success.rawValue)
    }
    catch { completion(error.localizedDescription) }
  }
  
  func loadRequests(_ callback: @escaping (String) -> Void) {
    userRequestController.getRequests { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        callback(response)
        return
      }
      
      self?.reFetch(callback)
    }
  }
  
  private func deleteRequest(_ id: Int, _ completion: @escaping (Bool) -> Void) {
    (userRequestController as! UserDataUpdating).deleteRequest(id: id) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.errorHandling.showWarningAlert(message: "Request has not been deleted! Contact the developer!")
          completion(false)
        }
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
