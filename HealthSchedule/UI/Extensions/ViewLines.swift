//
//  ViewLines.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum LinePosition {
  case top
  case bottom
}

extension UIView {
  func addLineToView(position : LinePosition, color: UIColor, width: CGFloat) {
    let lineView = UIView()
    lineView.backgroundColor = color
    lineView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(lineView)
    
    lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    lineView.heightAnchor.constraint(equalToConstant: width).isActive = true // Set Border-Strength
  }
}
