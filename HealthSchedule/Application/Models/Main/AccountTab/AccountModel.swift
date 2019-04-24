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
    
    dataSource.refresheData(from: user)
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
      //self?.initializeUserImage(from: user.image?.url)
      
      self?.dataSource.refresheData(from: user)
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
    
    commonDataRequestController.getImage(from: url, completion: accountHandlingDelegate.loadUserPhoto)
  }
  
  func changeText(by indexPath: IndexPath, with text: String?) {
    dataSource.data[indexPath.section].set(data: text, for: indexPath.row)
  }
  
  func changeStoredId(by indexPath: IndexPath, newId: Int) {
    dataSource.data[indexPath.section].set(id: newId, for: indexPath.row)
  }
  
  func handleSave() {
    var collectedData: Parser.JsonDictionary = [:]
    
    dataSource.data.forEach { item in
      let sectionJson = item.asJson()
      collectedData.merge(sectionJson, uniquingKeysWith: { thisKey, insertedKey in
        return thisKey
      })
    }
    
    (userRequestController as? UserDataUpdating)?.updateInfo(with: collectedData) {
      response in print(response)
    }
  }
}


class AccountDataSource: NSObject, UITableViewDataSource {
  var textFieldDelegate: UITextFieldDelegate!
  fileprivate var data: [AccountSectionDataContaining] = []
  
  fileprivate func refresheData(from user: User) {
    data = []
    
    data.append(GeneralInfoAccountSectionModel(user: user))
    data.append(SecureInfoAccountSectionModel(user: user))
    
    if user.role!.id == UserType.provider.rawValue {
      data.append(ProviderInfoAccountSectionModel(user: user))
    }
  }
  
  subscript(forSectionIndex: Int) -> AccountSectionDataContaining {
    return data[forSectionIndex]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // TODO: Split it
    
    let rowData = data[indexPath.section][indexPath.row]
    if rowData.type == .general {
      guard let placemarkCell = tableView.dequeueReusableCell(
        withIdentifier: AccountTableView.placemarkCellIdentifier,
        for: indexPath) as? AccountPlacemarkCell else {
          fatalError("Cannot cast to AccountPlacemarkCell!")
      }
      
      placemarkCell.configureCell(key: rowData.title, value: rowData.data, fieldSubtype: rowData.subtype, delegate: textFieldDelegate)
      placemarkCell.configureIdentity(identifier: indexPath, subType: rowData.subtype)
      
      return placemarkCell
    }
    
    guard let disclosureCell = tableView.dequeueReusableCell(
      withIdentifier: AccountTableView.disclosureCellIdentifier,
      for: indexPath) as? AccountDisclosureCell else {
        fatalError("Cannot cast to AccountDisclosureCell!")
    }
    
    disclosureCell.value = rowData.title
    
    return disclosureCell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
}
