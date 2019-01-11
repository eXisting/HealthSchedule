//
//  ContentViewCellRateable.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/10/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

protocol ContentViewCellRateable {
    
  func sendRate(rate: Int, with requestHandler: RateableRequesting)
  
}
