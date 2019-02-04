//
//  RoundButton.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

extension UIButton{
  func roundButton(by cornerRadius: CGSize){
    let maskPath = UIBezierPath(roundedRect: bounds,
                                 byRoundingCorners: [.topLeft , .topRight, .bottomLeft, .bottomRight],
                                 cornerRadii: cornerRadius)
    let maskLayer = CAShapeLayer()
    maskLayer.frame = bounds
    maskLayer.path = maskPath.cgPath
    layer.mask = maskLayer
  }
}
