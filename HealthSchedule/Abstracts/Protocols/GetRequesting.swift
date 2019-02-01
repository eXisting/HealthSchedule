//
//  ListsRequesting.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol GetRequesting {
  func getAsync(from url: String, _ params: Parser.JsonDictionary?, complition: @escaping (_ object: Any) -> Void)
}
