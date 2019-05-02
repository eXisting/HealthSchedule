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
  private let commonDataRequestController = CommonDataRequest()
  private var serviceName: String!
  private var providerService: ProviderService?

  let dataSource = ProviderSearchViewDataSource()
  
  func setupProviderCard(with id: Int, for service: Service, _ completion: @escaping (Bool) -> Void) {
    dataSource.service = service
    handleUserLoading(id, completion)
  }
  
  private func handleUserLoading(_ userId: Int, _ completion: @escaping (Bool) -> Void) {
    if let user = DataBaseManager.shared.fetchRequestsHandler.getUser(byId: userId, context: DataBaseManager.shared.mainContext) {
      process(user, completion)
      return
    }
    
    requestManager.getUser(by: userId) { [weak self] response in
      if response != ResponseStatus.success.rawValue {
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
    
    var tableViewData: [String] = []
    
    tableViewData.append(user.name!)
    tableViewData.append("Age: \(DateManager.shared.calculateAge(user.birthday!))")
    tableViewData.append("City: \(user.city?.name ?? "Unknown location")")

    dataSource.data = tableViewData
    
    initializeUserImage(from: user.image?.url) { [weak self] image in
      self?.dataSource.userPhoto = image
      completion(true)
    }
  }
  
  private func initializeUserImage(from url: String?, _ completion: @escaping (UIImage) -> Void) {
    let defaultImage = UIImage(named: "Pictures/chooseProfile")!
    
    guard let url = url else {
      completion(defaultImage)
      return
    }
    
    let isRemoteImage = url.contains("http")
    
    if let cachedImage = CacheManager.shared.getFromCache(by: url as AnyObject) as? UIImage {
      completion(cachedImage)
      return
    }
    
    commonDataRequestController.getImage(from: url, isLaravelRelated: !isRemoteImage) { data in
      guard let data = data else {
        completion(defaultImage)
        return
      }
      
      guard let image = UIImage(data: data) else {
        completion(defaultImage)
        return
      }
      
      CacheManager.shared.saveToCache(url as AnyObject, image)
      completion(image)
    }
  }

}
