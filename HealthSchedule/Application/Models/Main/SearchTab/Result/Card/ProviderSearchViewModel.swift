//
//  ProviderSearchViewModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderSearchViewModel {
  private let requestManager: CommonDataRequesting = UserDataRequest()
  
  let dataSource = ProviderSearchViewDataSource()
  
  func setupProviderCard(with id: Int) {
    if let user = DataBaseManager.shared.fetchRequestsHandler.getUser(byId: id, context: DataBaseManager.shared.mainContext) {
      DispatchQueue.global(qos: .userInteractive).async {
        self.process(user)
      }
      
      return
    }
    
    requestManager.getUser(by: id) { response in
      if response != ResponseStatus.success.rawValue {
        print(response)
        return
      }
      
      if let user = DataBaseManager.shared.fetchRequestsHandler.getUser(byId: id, context: DataBaseManager.shared.mainContext) {
        self.process(user)
      }
    }
  }
  
  private func process(_ user: User) {
    // TODO: Init data source
    print(user.name)
  }
}

class ProviderSearchViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
