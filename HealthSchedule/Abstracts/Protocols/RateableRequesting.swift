//
//  RateableRequesting.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

protocol RateableRequesting {
  func postRate(for url: String, withRate rate: Int)
  func getRate(from url: String) -> Int
}
