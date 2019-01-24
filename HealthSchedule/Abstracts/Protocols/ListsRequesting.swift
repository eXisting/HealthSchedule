//
//  ListsRequesting.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol ListsRequesting {
  
  func getAsync(from url: String, complition: @escaping (_ list: [Any]) -> Void)
  func getAsync(from url: String, with params: String, complition: @escaping (_ list: [Any]) -> Void)
  
}
