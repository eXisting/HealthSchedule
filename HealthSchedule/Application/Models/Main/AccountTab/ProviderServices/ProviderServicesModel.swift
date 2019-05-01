//
//  ProviderServicesModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServicesModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  private var errorHandling: ErrorShowable
  private var source = ProviderServicesDataSource()
  
  init(errorDelegate: ErrorShowable, loaderDelegate: LoaderShowable) {
    errorHandling = errorDelegate
    
    source.loaderHandler = loaderDelegate
    source.deleteHandler = deleteService
  }
  
  func reFetch(_ completion: @escaping (String) -> Void) {
    do {
      try DataBaseManager.shared.providerServicesFrc.performFetch()
      completion(ResponseStatus.success.rawValue)
    }
    catch { completion(error.localizedDescription) }
  }
  
  func loadServices(_ completion: @escaping (String) -> Void) {
    requestManager.getProviderServices { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        completion(response)
        return
      }
      
      self?.reFetch(completion)
    }
  }
  
  private func deleteService(_ id: Int, _ completion: @escaping (Bool) -> Void) {
    requestManager.removeProviderService(with: id) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.errorHandling.showWarningAlert(message: "Service has not been deleted! Contact the developer!")
          completion(false)
        }
        return
      }
      
      completion(true)
    }
  }
}

extension ProviderServicesModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
