//
//  RoundImageHandler.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ImageType: String {
  case Thumbnail = "thumbnail"
  case MediumImage = "medium"
  case BigImage = "big"
}

extension UIImageView {
  func roundImageBy(divider: Float) {
    self.layer.cornerRadius = self.frame.height / CGFloat(divider)
    self.clipsToBounds = true
  }
}
