//
//  AccountModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountModel {
  private let userRequestController: CommonDataRequesting = UserDataRequest()
  private let commonDataRequestController = CommonDataRequest()

  private unowned var accountHandlingDelegate: AccountHandlableDelegate
  
  let dataSource = AccountDataSource()
  var presentedIdetifier: IndexPath?
  
  init(accountHandlingDelegate: AccountHandlableDelegate) {
    self.accountHandlingDelegate = accountHandlingDelegate
    
    guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      print("AccountModel failed!")
      return
    }
    
    dataSource.instantiate(from: user)
    initializeUserImage(from: user.image?.url)
  }
  
  func reloadRemoteUser(_ completion: @escaping (String) -> Void) {
    userRequestController.getUser {
      [weak self] response in
      if response != ResponseStatus.success.rawValue {
        completion(response)
        return
      }
      
      guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      // urlsession Error code 1002
      self?.initializeUserImage(from: user.image?.url)
      
      self?.dataSource.instantiate(from: user)
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func getCities(_ completion: @escaping ([City]) -> Void) {
    let cachedCities = DataBaseManager.shared.fetchRequestsHandler.getCties(context: DataBaseManager.shared.mainContext)
    if cachedCities.count > 1 {
      completion(cachedCities)
      return
    }
    
    commonDataRequestController.getCities { status in
      if status == ResponseStatus.success.rawValue {
        completion(DataBaseManager.shared.fetchRequestsHandler.getCties(context: DataBaseManager.shared.mainContext))
      }
    }
  }
  
  func initializeUserImage(from url: String?) {
    guard let url = url else { return }
    
    if let cachedImage = CacheManager.shared.getFromCache(by: url as AnyObject) as? UIImage {
      accountHandlingDelegate.set(image: cachedImage)
      return
    }
    
    commonDataRequestController.getImage(from: url, isLaravelRelated: false) { [weak self] data in
      guard let image = UIImage(data: data) else {
        self?.accountHandlingDelegate.set(image: UIImage(named: "Pictures/chooseProfile")!)
        return
      }
      
      CacheManager.shared.saveToCache(url as AnyObject, image)
      self?.accountHandlingDelegate.set(image: image)
    }
  }
  
  func changeText(by indexPath: IndexPath, with text: String?) {
    dataSource[indexPath.section].set(data: text, for: indexPath.row)
  }
  
  func changeStoredId(by indexPath: IndexPath, newId: Int) {
    dataSource[indexPath.section].set(id: newId, for: indexPath.row)
  }
  
  func handleSave() {
    (userRequestController as? UserDataUpdating)?.updateInfo(with: dataSource.collectData()) {
      response in print(response)
    }
  }
}
