//
//  ProviderProfessionModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderProfessionModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  private let commonRequests = CommonDataRequest()
  private var existingProfession: ProviderProfession?
  
  let dataSource = ProviderProfessionCardDataSource()
  
  var professionIdentifier: IndexPath?
  var cityIdentifier: IndexPath?

  init(profession: ProviderProfession?) {
    existingProfession = profession
  }
  
  func instantiateData() {
    dataSource.data = [
      ProviderProfessionGeneralSectionModel(profession: existingProfession),
      ProviderProfessionTimeIntervalSectionModel(profession: existingProfession)
    ]
  }
  
  func saveProviderProfession(_ completion: @escaping (String) -> Void) {
    requestManager.createUpdateProviderProfession(with: collectData(), isCreate: existingProfession == nil, completion: completion)
  }
  
  func getCities(_ completion: @escaping ([City]) -> Void) {
    let cachedCities = DataBaseManager.shared.fetchRequestsHandler.getCties(context: DataBaseManager.shared.mainContext)
    if cachedCities.count > 1 {
      completion(cachedCities)
      return
    }
    
    commonRequests.getCities { status in
      if status == ResponseStatus.success.rawValue {
        completion(DataBaseManager.shared.fetchRequestsHandler.getCties(context: DataBaseManager.shared.mainContext))
      }
    }
  }
  
  func getProfessions(_ completion: @escaping ([Profession]) -> Void) {
    let cached = DataBaseManager.shared.fetchRequestsHandler.getProfessions(context: DataBaseManager.shared.mainContext)
    if cached.count > 1 {
      completion(cached)
      return
    }
    
    commonRequests.getProfessions { status in
      if status == ResponseStatus.success.rawValue {
        completion(DataBaseManager.shared.fetchRequestsHandler.getProfessions(context: DataBaseManager.shared.mainContext))
      }
    }
  }
  
  func setPickedProfession(for path: IndexPath, professionId: Int?, professionName: String?) {
    var rowData = dataSource.data[path.section][path.row]
    rowData.data = professionName
    rowData.id = professionId
  }
  
  func setPickedCity(for path: IndexPath, cityId: Int?, cityName: String?) {
    var rowData = dataSource.data[path.section][path.row]
    rowData.data = cityName
    rowData.id = cityId
  }
  
  subscript(forSectionIndex: Int) -> ProviderProfessionSectionDataContaining {
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
    
    if let providerProfession = existingProfession {
      result[ProfessionJsonFields.id.rawValue] = String(providerProfession.id)
    }
    
    return result
  }
}

class ProviderProfessionCardDataSource: NSObject, UITableViewDataSource {
  var textFieldDelegate: UITextFieldDelegate!
  fileprivate var data: [ProviderProfessionSectionDataContaining] = []
  
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
    
    return cell
  }
}
