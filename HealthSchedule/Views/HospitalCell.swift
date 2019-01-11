//
//  HospitalCell.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/10/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

final class HospitalCell: UICollectionViewCell, ContentViewCellPlaceable, ContentViewCellRateable {
  
  @IBOutlet weak var backgroundImage: UIImageView!
  
  // MARK: - ContentViewCellPlaceable
  
  var rate: Int?
  
  func sendRate(rate: Int, with requestHandler: RateableRequesting) {
    
  }
  
  // MARK: - ContentViewCellPlaceable
  
  var identity: String?
  
  var name: String?
  
  var thumbnailImage: UIImage?
  
  var largeImage: UIImage?
  
  var shortDescription: String?
}

//extension HospitalCell: ContentViewCellPlaceable {
//
//}
//
//extension HospitalCell: ContentViewCellRateable {
//
//}
