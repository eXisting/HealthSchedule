//
//  ChosenProviderModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ChosenProviderModel {
  private let requestManager: CommonDataRequesting = UserDataRequest()
  private let source = ChosenProviderDataSource()

  private var errorHandling: ErrorShowable
  private var loaderHandling: LoaderShowable
  
  private var providerId: Int
  private var serviceId: Int
  private(set) var time: Date
  
  init(errorDelegate: ErrorShowable, loaderDelegate: LoaderShowable,
       _ providerId: Int, _ serviceId: Int, _ time: Date
  ) {
    self.providerId = providerId
    self.serviceId = serviceId
    self.time = time
    
    loaderHandling = loaderDelegate
    errorHandling = errorDelegate
  }
  
  func loadServices(_ completion: @escaping () -> Void) {
    loaderHandling.showLoader()
    print(providerId)
    print(serviceId)
    requestManager.getProviderBookingServices(for: providerId, serviceId: serviceId) {
      [weak self] response in
      
      if response != ResponseStatus.success.rawValue {
        self?.stopLoader(with: response)
        return
      }
      
      guard let serviceId = self?.serviceId, let providerId = self?.providerId else {
        self?.stopLoader(with: ResponseStatus.applicationError.rawValue)
        return
      }
      
      let searchPredicate = NSPredicate(format: "providerId == \(Int32(providerId)) && serviceId == \(Int16(serviceId))")
      let bookingServices = DataBaseManager.shared.fetchRequestsHandler.getProviderServices(with: searchPredicate, context: DataBaseManager.shared.mainContext)
      
      self?.source.populateServices(bookingServices)
      
      completion()
    }
  }
  
  subscript(index: Int) -> ProviderService {
    return source[index]
  }
  
  private func stopLoader(with message: String) {
    DispatchQueue.main.async {
      self.errorHandling.showWarningAlert(message: message)
      self.loaderHandling.hideLoader()
    }
  }
}

extension ChosenProviderModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
