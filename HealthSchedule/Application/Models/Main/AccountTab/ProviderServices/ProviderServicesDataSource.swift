//
//  ProviderServicesDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/3/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderServicesDataSource: NSObject, UITableViewDataSource {
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
}
