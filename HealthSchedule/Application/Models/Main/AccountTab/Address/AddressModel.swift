//
//  AddressModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/24/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AddressModel {
  private let requestManager: ProviderInfoRequesting = UserDataRequest()
  
  func getAddress() -> String {
    let address = DataBaseManager.shared.fetchRequestsHandler.getCurrentUserAddress(context: DataBaseManager.shared.mainContext)
    
    return address?.address ?? ""
  }
  
  func saveAddress(newAddress: String, _ completion: @escaping (String) -> Void) {
    requestManager.saveAddress(newAddress, completion: completion)
  }
}
