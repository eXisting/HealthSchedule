//
//  CreateProviderServiceModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServiceModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  private var existingService: ProviderService?
  
  let dataSource = ProviderServiceCardDataSource()
  
  init(service: ProviderService?) {
    existingService = service
  }
  
  func postService(_ completion: @escaping (String) -> Void) {
    requestManager.createUpdateProviderService(with: [:], isCreate: existingService == nil, completion: completion)
  }
  
  subscript(forSectionIndex: Int) -> ProviderServiceSectionDataContaining {
    return dataSource.data[forSectionIndex]
  }
  
  func procceed() {
    dataSource.data = [
      ProviderServiceGeneralSectionModel(service: existingService),
      ProviderServiceDurationSectionModel(service: existingService)
    ]
  }
  
  func changeText(by indexPath: IndexPath, with text: String?) {
    dataSource.data[indexPath.section].set(data: text, for: indexPath.row)
  }
}

class ProviderServiceCardDataSource: NSObject, UITableViewDataSource {
  var textFieldDelegate: UITextFieldDelegate!
  fileprivate var data: [ProviderServiceSectionDataContaining] = []
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].numberOfRows
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return data[section].sectionName
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rowData = data[indexPath.section][indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: ProviderCreateTableView.cellIdentifier, for: indexPath) as! ProviderServiceCreateRow
      
    cell.configureIdentity(identifier: indexPath, subType: rowData.subtype)
    cell.configureCell(key: rowData.title, value: rowData.data, delegate: textFieldDelegate)
    
    return cell
  }
}
