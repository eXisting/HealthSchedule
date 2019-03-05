//
//  RoundButton.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

extension UIView {
  func roundCorners(by cornerRadius: CGFloat){
    layer.cornerRadius = cornerRadius
    clipsToBounds = true
  }
}
