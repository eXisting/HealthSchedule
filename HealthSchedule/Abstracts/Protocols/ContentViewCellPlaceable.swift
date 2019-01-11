//
//  ContentViewCellPlaceable.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/10/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ContentViewCellType {
  case Expert
  case Hospital
  case Exercise
}

protocol ContentViewCellPlaceable {
  var identity: String? { get }
  var name: String? { get }
  var thumbnailImage: UIImage? { get }
  var largeImage: UIImage? { get }
  var shortDescription: String? { get }
}
