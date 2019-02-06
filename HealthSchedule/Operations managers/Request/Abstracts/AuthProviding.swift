//
//  AuthProviding.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol AuthProviding {
  // Get token, you need to get user internally in completion
  func getToken(from url: String, body: Data, completion: @escaping UrlSessionHandler.PostCompletion)
}
