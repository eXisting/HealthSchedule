//
//  ImageColorChange.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

extension UIImageView {
  func changeColor(to color: UIColor) {
    image = image!.withRenderingMode(.alwaysTemplate)
    tintColor = color
  }
  
  func makeCircleBorder(with color: CGColor, _ borderRadius: CGFloat) {
    layer.borderWidth = borderRadius
    layer.masksToBounds = false
    layer.borderColor = color
    layer.cornerRadius = frame.height / 2
    clipsToBounds = true
  }
}
