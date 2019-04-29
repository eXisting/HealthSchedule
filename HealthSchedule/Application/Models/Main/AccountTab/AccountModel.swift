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

  private let source = AccountDataSource()
  private unowned var accountHandlingDelegate: AccountHandlableDelegate
  
  var userImageData: Data?
  var imageName: String?
  var presentedIdetifier: IndexPath?
  
  init(accountHandlingDelegate: AccountHandlableDelegate, textFieldDelegate: UITextFieldDelegate) {
    self.accountHandlingDelegate = accountHandlingDelegate
    
    guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      print("AccountModel failed!")
      return
    }
    
    source.instantiate(from: user)
    source.setDelegate(textFieldDelegate)
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
      
      self?.source.instantiate(from: user)
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
    
    let isRemoteImage = url.contains("http")
    let splited = url.split(separator: Character("/"))
    
    imageName = String(splited.last!)
    
    if let cachedImage = CacheManager.shared.getFromCache(by: url as AnyObject) as? UIImage {
      accountHandlingDelegate.set(image: cachedImage)
      userImageData = cachedImage.jpegData(compressionQuality: 1)
      return
    }
    
    commonDataRequestController.getImage(from: url, isLaravelRelated: !isRemoteImage) {
      [weak self] data in
      guard let data = data else {
        self?.accountHandlingDelegate.set(image: UIImage(named: "Pictures/chooseProfile")!)
        return
      }
      
      guard let image = UIImage(data: data) else {
        self?.accountHandlingDelegate.set(image: UIImage(named: "Pictures/chooseProfile")!)
        return
      }
      
      CacheManager.shared.saveToCache(url as AnyObject, image)
      self?.accountHandlingDelegate.set(image: image)
      self?.userImageData = image.jpegData(compressionQuality: 1)
    }
  }
  
  func changeText(by indexPath: IndexPath, with text: String?) {
    source[indexPath.section].set(data: text, for: indexPath.row)
  }
  
  func changeStoredId(by indexPath: IndexPath, newId: Int) {
    source[indexPath.section].set(id: newId, for: indexPath.row)
  }
  
  func handleSave(completion: @escaping (String) -> Void) {
    guard let updatingRequestManager = userRequestController as? UserDataUpdating else {
      fatalError()
    }
    
    updatingRequestManager.updateInfo(with: source.collectData()) { response in
      if response != ResponseStatus.success.rawValue {
        completion(response)
      }
    }
    
    guard let photoData = userImageData,
      let photoName = imageName else { return }
    
    var info: Parser.JsonDictionary = [:]
    info[ProfileImageJsonFields.filename.rawValue] = photoName
    info[ProfileImageJsonFields.mimeType.rawValue] = "image/jpeg"

    updatingRequestManager.updatePhoto(with: photoData, infoDict: info, completion)
  }
  
  subscript(forSectionIndex: Int) -> AccountSectionDataContaining {
    return source[forSectionIndex]
  }
}

extension AccountModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
