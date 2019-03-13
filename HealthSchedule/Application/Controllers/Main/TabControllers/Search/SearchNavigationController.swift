//
//  HomeNavigationController.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SearchNavigationController: UINavigationController {
  private let servicesController = ServicesViewController()
  private let providerController = ProviderViewController()
  private let timetableController = TimetableViewController()

  func pushController(for searchOption: SearchOptionKey) {
    switch searchOption {
      case .service:
        pushServiceController()
      case .dateTime:
        pushTimetableController()
      case .provider:
        pushProviderController()
    }
  }
  
  private func pushServiceController() {
    pushViewController(servicesController, animated: true)
  }
  
  private func pushProviderController() {
    pushViewController(providerController, animated: true)
  }
  
  private func pushTimetableController() {
    pushViewController(timetableController, animated: true)
  }
}
