//
//  ListsRequesting.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol Requesting {
  func getAsync(from url: String, _ params: Parser.JsonDictionary?, completion: @escaping (Any) -> Void)
  func postAsync(to url: String, as type: RequestType, _ body: Data, _ params: Parser.JsonDictionary?, completion: @escaping RequestHandler.PostCompletion)
}
