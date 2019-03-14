//
//  AccountNavigationController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class AccountNavigationController: UINavigationController {
  
  // MARK: Common
  
  private let passwordController = UIViewController()
  
  // MARK: Provider
  
  private let addressController = UIViewController()
  private let serviceController = UIViewController()
  private let scheduleController = UIViewController()
  private let professionController = UIViewController()
  
  func pushController(for disclosureType: DisclosureFieldType) {
    switch disclosureType {
    case .profession:
      pushProfessionController()
    case .service:
      pushServiceController()
    case .address:
      pushAddressController()
    case .schedule:
      pushScheduleController()
    case .password:
      pushPasswordController()
    case .none:
      break
    }
  }
  
  // MARK: Main navigation
  
  private func pushProfessionController() {
    pushViewController(professionController, animated: true)
  }
  
  private func pushServiceController() {
    pushViewController(serviceController, animated: true)
  }
  
  private func pushAddressController() {
    pushViewController(addressController, animated: true)
  }
  
  private func pushScheduleController() {
    pushViewController(scheduleController, animated: true)
  }
  
  private func pushPasswordController() {
    pushViewController(passwordController, animated: true)
  }
}
