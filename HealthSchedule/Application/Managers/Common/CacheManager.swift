//
//  CacheManage.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/29/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class CacheManager {
  static let shared = CacheManager()
  private init() {
    storage.countLimit = 100
  }
  
  private let storage = NSCache<AnyObject, AnyObject>()
  
  func saveToCache(_ hashedKey: AnyObject, _ value: AnyObject) {
    storage.setObject(value, forKey: hashedKey)
  }
  
  func getFromCache(by key: AnyObject) -> AnyObject? {
    return storage.object(forKey: key)
  }
  
  func clearCache() {
    storage.removeAllObjects()
  }
}
