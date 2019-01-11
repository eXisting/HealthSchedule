//
//  BaseUIContentViewCell.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/11/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ContentViewCellType {
  case Expert
  case Hospital
  case Exercise
}

final class BaseUICollectionViewCell: UICollectionViewCell, ContentViewCellRateable {
  
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var fullName: UILabel!
  @IBOutlet weak var fullDescription: UILabel!
  
  func sendRate(rate: Int, with requestHandler: RateableRequesting) {
    
  }
}
