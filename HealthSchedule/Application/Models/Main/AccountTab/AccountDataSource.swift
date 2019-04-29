//
//  AccountDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/27/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountDataSource: NSObject, UITableViewDataSource {
  private var data: [AccountSectionDataContaining] = []
  
  private var textFieldDelegate: UITextFieldDelegate!
  
  func instantiate(from user: User) {
    data = [
      GeneralInfoAccountSectionModel(user: user),
      SecureInfoAccountSectionModel(user: user)
    ]
    
    if user.roleId == UserType.provider.rawValue {
      data.append(ProviderInfoAccountSectionModel(user: user))
    }
  }
  
  func setDelegate(_ textFieldDelegate: UITextFieldDelegate) {
    self.textFieldDelegate = textFieldDelegate
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
  
  func collectData() -> Parser.JsonDictionary {
    var collectedData: Parser.JsonDictionary = [:]
    
    data.forEach { item in
      let sectionJson = item.asJson()
      collectedData.merge(sectionJson, uniquingKeysWith: { thisKey, insertedKey in
        return thisKey
      })
    }
    
    return collectedData
  }
}
