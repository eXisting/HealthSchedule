//
//  ChosenProviderModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 5/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ChosenProviderModel {
  private var source: ChosenProviderDataSource!
  
  init(_ providerId: Int, _ serviceId: Int, _ time: Date) {
    source = ChosenProviderDataSource()
  }
}

extension ChosenProviderModel: DataSourceContaining {
  var dataSource: UITableViewDataSource {
    return source
  }
}
