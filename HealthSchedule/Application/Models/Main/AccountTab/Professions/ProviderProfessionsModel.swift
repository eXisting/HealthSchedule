//
//  ProviderProfessionsModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderProfessionsModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  private var errorHandling: ErrorShowable
  private var source = ProviderProfessionsDataSource()
  
  init(errorDelegate: ErrorShowable, loaderDelegate: LoaderShowable) {
    errorHandling = errorDelegate
    
    source.loaderHandler = loaderDelegate
    source.deleteHandler = deleteProfession
  }
  
  func reFetch(_ completion: @escaping (String) -> Void) {
    do {
      try DataBaseManager.shared.providerProfessionFrc.performFetch()
      completion(ResponseStatus.success.rawValue)
    }
    catch { completion(error.localizedDescription) }
  }
  
  func loadProviderProfessions(_ completion: @escaping (String) -> Void) {
    requestManager.getProviderProfessions(with: nil) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        completion(response)
        return
      }
      
      self?.reFetch(completion)
    }
  }
  
  private func deleteProfession(_ id: Int, _ completion: @escaping (Bool) -> Void) {
    requestManager.removeProfession(with: id) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.errorHandling.showWarningAlert(message: "Profession has not been deleted! Contact the developer!")
          completion(false)
        }
        return
      }
      
      completion(true)
    }
  }
}

extension ProviderProfessionsModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
