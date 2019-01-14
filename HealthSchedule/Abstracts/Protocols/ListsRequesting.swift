//
//  ListsRequesting.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ListsRequesting {
  
  func get(from url: String, complition: @escaping () -> Void) -> [Any]
  func get(from url: String, with query: String, complition: @escaping () -> Void) -> [Any]
  
}
