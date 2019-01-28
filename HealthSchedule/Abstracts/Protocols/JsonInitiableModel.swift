//
//  ModelInitiable.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol JsonInitiableModel {
  init?(json: [String: Any])
}
