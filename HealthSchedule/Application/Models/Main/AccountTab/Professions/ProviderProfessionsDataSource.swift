//
//  ProviderProfessionsDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderProfessionsDataSource: NSObject, UITableViewDataSource {
  var deleteHandler: ((Int, @escaping (Bool) -> Void) -> Void)!
  var loaderHandler: LoaderShowable!
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DataBaseManager.shared.providerProfessionFrc.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ProviderProfessionsView.cellIdentifier, for: indexPath) as! ProviderProfessionViewCell
    
    let providerProfession = DataBaseManager.shared.providerProfessionFrc.object(at: indexPath)
    
    cell.setupData(id: Int(providerProfession.id), city: providerProfession.city!.name!, company: providerProfession.companyName!)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let providerProfession = DataBaseManager.shared.providerProfessionFrc.object(at: indexPath)
      
      loaderHandler.showLoader()
      
      deleteHandler(Int(providerProfession.id)) { [weak self] isSuccess in
        if isSuccess {
          DataBaseManager.shared.delete(with: providerProfession.objectID)
        }
        
        DispatchQueue.main.async {
          self?.loaderHandler.hideLoader()
        }
      }
    }
  }
}
