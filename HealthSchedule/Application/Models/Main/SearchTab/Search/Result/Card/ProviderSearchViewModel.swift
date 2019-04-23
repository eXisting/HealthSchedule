//
//  ProviderSearchViewModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderSearchViewModel {
  private let requestManager: CommonDataRequesting = UserDataRequest()
  private var serviceName: String!
  private var providerService: ProviderService?

  let dataSource = ProviderSearchViewDataSource()
  
  func setupProviderCard(with id: Int, for service: Service, _ completion: @escaping (Bool) -> Void) {
    handleProviderServiceLoading(Int(service.id))
    handleUserLoading(id, completion)
  }
  
  private func handleProviderServiceLoading(_ serviceId: Int) {
    // TODO: Rewrite backend
  }
  
  private func handleUserLoading(_ userId: Int, _ completion: @escaping (Bool) -> Void) {
    if let user = DataBaseManager.shared.fetchRequestsHandler.getUser(byId: userId, context: DataBaseManager.shared.mainContext) {
      process(user, completion)
      return
    }
    
    requestManager.getUser(by: userId) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
        print(response)
        completion(false)
        return
      }
      
      if let user = DataBaseManager.shared.fetchRequestsHandler.getUser(byId: userId, context: DataBaseManager.shared.mainContext) {
        self?.process(user, completion)
        return
      }
      
      completion(false)
    }
  }
  
  private func process(_ user: User, _ completion: @escaping (Bool) -> Void) {
    dataSource.data = []
    
    var tableViewData: [Any] = []
    
    tableViewData.append(user.name as Any)
    tableViewData.append("Age: \(DateManager.shared.calculateAge(user.birthday!))" as Any)
    tableViewData.append("City: \(user.city?.name ?? "Unknown location")" as Any)
    tableViewData.append("Price: Free" as Any)
    tableViewData.append("Service: Unknown service" as Any)

    dataSource.data = tableViewData
    dataSource.userPhotoData = user.image?.url
    
    completion(true)
  }
}
