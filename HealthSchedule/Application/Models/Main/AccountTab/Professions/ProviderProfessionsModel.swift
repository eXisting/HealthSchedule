//
//  ProviderProfessionsModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderProfessionsModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  var dataSource = ProviderProfessionsDataSource()
  
  func prefetch() {
    do {
      try DataBaseManager.shared.providerProfessionFrc.performFetch()
    }
    catch { print(error.localizedDescription) }
  }
  
  func loadProviderProfessions(_ completion: @escaping (String) -> Void) {
    requestManager.getProviderProfessions(with: nil) { response in
      do {
        try DataBaseManager.shared.providerProfessionFrc.performFetch()
        completion(response)
      }
      catch { completion(error.localizedDescription) }
    }
  }
}

class ProviderProfessionsDataSource: NSObject, UITableViewDataSource {
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
}

