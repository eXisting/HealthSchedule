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
  private let commonRequests = CommonDataRequest()
  private var existingService: ProviderService?
  
  let dataSource = ProviderServiceCardDataSource()
  
  var serviceIdentifier: IndexPath?
  
  init(service: ProviderService?) {
    existingService = service
  }
  
  func instantiateData() {
    dataSource.data = [
      ProviderServiceGeneralSectionModel(service: existingService),
      ProviderServiceDurationSectionModel(service: existingService)
    ]
  }
  
  func postService(_ completion: @escaping (String) -> Void) {
    var data = collectData()
    requestManager.createUpdateProviderService(with: data, isCreate: existingService == nil, completion: completion)
  }
  
  func loadServices(_ completion: @escaping ([Service]) -> Void) {
    let services = DataBaseManager.shared.fetchRequestsHandler.getServices(context: DataBaseManager.shared.mainContext)
    if services.count > 1 {
      completion(services)
      return
    }

    commonRequests.getAllServices { status in
      if status != ResponseStatus.success.rawValue { return }
      completion(DataBaseManager.shared.fetchRequestsHandler.getServices(context: DataBaseManager.shared.mainContext))
    }
  }
  
  func setPickedService(for path: IndexPath, serviceId: Int?, serviceName: String?) {    
    var rowData = dataSource.data[path.section][path.row]
    rowData.data = serviceName
    rowData.id = serviceId
  }
  
  subscript(forSectionIndex: Int) -> ProviderServiceSectionDataContaining {
    return dataSource.data[forSectionIndex]
  }
  
  func changeText(by indexPath: IndexPath, with text: String?) {
    dataSource.data[indexPath.section].set(data: text, for: indexPath.row)
  }
  
  private func collectData() -> Parser.JsonDictionary {
    var result: Parser.JsonDictionary = [:]
    
    dataSource.data.forEach { item in
      let sectionJson = item.asJson()
      result.merge(sectionJson, uniquingKeysWith: { thisKey, insertedKey in
        return thisKey
      })
    }
    
    if let service = existingService {
      result["id"] = String(service.id)
    }
    
    return result
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
    let cell = tableView.dequeueReusableCell(withIdentifier: ProviderServiceGeneralTableView.cellIdentifier, for: indexPath) as! GeneralIdentifyingRow
      
    cell.configureIdentity(identifier: indexPath, subType: rowData.subtype)
    cell.configureCell(key: rowData.title, value: rowData.data, delegate: textFieldDelegate)
    cell.setupDatePicker(.time, format: .time, locale: .hour24, 20)
    
    return cell
  }
}
