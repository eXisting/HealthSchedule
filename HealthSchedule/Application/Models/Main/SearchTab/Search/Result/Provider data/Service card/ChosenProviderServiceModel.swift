//
//  ChosenProviderServiceModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ChosenProviderServiceModel {
  private let requestManager: UserDataUpdating = UserDataRequest()
  private let source = ChosenProviderServiceDataSource()

  private var errorHandling: ErrorShowable
  private var loaderHandling: LoaderShowable
 
  private var time: Date
  private var service: ProviderService
  
  private var userType: UserType?
  
  init(errorDelegate: ErrorShowable, loaderDelegate: LoaderShowable, _ service: ProviderService, _ time: Date) {
    self.time = time
    self.service = service
    
    loaderHandling = loaderDelegate
    errorHandling = errorDelegate
    
    serviceToData()
  }
  
  func sendRequest(_ completion: @escaping () -> Void) {
    loaderHandling.showLoader()
    
    var data: Parser.JsonDictionary = [:]
    data[RequestJsonFields.requestAt.rawValue] = DateManager.shared.date2String(with: .dateTime, time, .posix)
    data[ProviderServiceJsonFields.providerServiceId.rawValue] = String(service.id)
    data[RequestJsonFields.description.rawValue] = "Hello, I would like to book!"
    
    requestManager.makeRequests(toProviderWith: data) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        DispatchQueue.main.async {
          self?.loaderHandling.hideLoader()
          self?.errorHandling.showWarningAlert(message: response)
        }
        return
      }
      
      completion()
    }
  }
  
  func getCurrentUserType() -> UserType {
    if let type = userType {
      return type
    }
    
    guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError()
    }
    
    guard let role = UserType(rawValue: Int(user.roleId)) else {
      fatalError()
    }
    
    userType = role
    
    return role
  }
  
  private func serviceToData() {
    var data: [String] = []
    
    data.append("Provider: \(service.provider!.name!)")
    data.append("General service: \(service.service!.name!)")
    data.append("Name: \(service.name!)")
    data.append("Price: \(service.price)")
    data.append("Address: \(service.address!.address!)")
    data.append("Duration: \(DateManager.shared.date2String(with: .time, service.duration!, .hour24))")
    
    source.populateData(data)
  }
}

extension ChosenProviderServiceModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
