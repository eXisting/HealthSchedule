//
//  ProviderServicesDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServicesDataSource: NSObject, UITableViewDataSource {
  var deleteHandler: ((Int, @escaping (Bool) -> Void) -> Void)!
  var loaderHandler: LoaderShowable!
  
  func numberOfSections(in tableView: UITableView) -> Int {
    //    if let sections = DataBaseManager.shared.providerServicesFrc.sections {
    //      return sections.count
    //    }
    
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    if let sections = DataBaseManager.shared.providerServicesFrc.sections {
    //      let currentSection = sections[section]
    //      return currentSection.numberOfObjects
    //    }
    
    return DataBaseManager.shared.providerServicesFrc.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProviderServicesTableView.cellIdentifier, for: indexPath) as! ProviderServiceCell
    
    let providerService = DataBaseManager.shared.providerServicesFrc.object(at: indexPath)
    
    cell.setupData(id: Int(providerService.id), price: providerService.price, duration: providerService.duration)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      loaderHandler.showLoader()
      
      let providerService = DataBaseManager.shared.providerServicesFrc.object(at: indexPath)
      
      deleteHandler(Int(providerService.id)) { [weak self] isSuccess in
        if isSuccess {
          DataBaseManager.shared.delete(with: providerService.objectID)
        }
        
        DispatchQueue.main.async {
          self?.loaderHandler.hideLoader()          
        }
      }
    }
  }
}