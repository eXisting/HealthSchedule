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
  func addLineToView(position : LinePosition, color: UIColor, width: CGFloat, _ leftOffset: CGFloat = 0, _ rightOffset: CGFloat = 0) {
    let lineView = UIView()
    lineView.backgroundColor = color
    lineView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(lineView)
    
    lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: self.frame.height * -0.25).isActive = true
    lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: leftOffset).isActive = true
    lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -rightOffset).isActive = true
    lineView.heightAnchor.constraint(equalToConstant: width).isActive = true
  }
}
