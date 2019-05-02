//
//  ChosenProviderDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ChosenProviderDataSource: NSObject, UITableViewDataSource {
  private var services: [ProviderService] = []
  
  func populateServices(_ services: [ProviderService]) {
    self.services = services
  }
  
  subscript(index: Int) -> ProviderService {
    return services[index]
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return services.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProviderServicesTableView.cellIdentifier, for: indexPath) as! ProviderServiceCell
    
    let providerService = services[indexPath.row]
    
    cell.setupData(id: Int(providerService.id), price: providerService.price, name: providerService.name!, duration: providerService.duration)
    
    return cell
  }  
}
