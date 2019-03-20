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
  private let databaseManager = DataBaseManager.shared
  
  let dataSource = AccountDataSource()
  
  init() {
    guard let user = databaseManager.getCurrentUser() else {
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
      
      guard let user = self?.databaseManager.getCurrentUser() else {
        completion(ResponseStatus.applicationError.rawValue)
        return
      }
      
      self?.dataSource.refresheData(from: user)
      completion(ResponseStatus.success.rawValue)
    }
  }
  
  func changeText(by indexPath: IndexPath, with text: String?) {
    dataSource.data[indexPath.section].set(data: text, for: indexPath.row)
  }
  
  func handleSave() {
    // TODO
  }
}


class AccountDataSource: NSObject, UITableViewDataSource {
  var textFieldDelegate: UITextFieldDelegate!
  fileprivate var data: [AccountSectionDataContaining] = []
  
  fileprivate func refresheData(from user: User) {
    data = []
    
    data.append(GeneralInfoAccountSectionModel(user: user))
    data.append(SecureInfoAccountSectionModel(user: user))
    //if user.role?.name == "provider" {
    data.append(ProviderInfoAccountSectionModel(user: user))
    //}
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
      
      placemarkCell.setPlaceholderWithText(rowData.title)
      placemarkCell.value = rowData.data
      placemarkCell.delegate = textFieldDelegate
      placemarkCell.identifier = indexPath
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
