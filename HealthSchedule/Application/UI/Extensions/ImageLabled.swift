//
//  ImageLabled.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/12/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

extension UITextField {
  func setIcon(_ image: UIImage) {
    let iconView = UIImageView(frame:
      CGRect(x: 10, y: 5, width: 20, height: 20))
    iconView.image = image
    let iconContainerView: UIView = UIView(frame:
      CGRect(x: 20, y: 0, width: 30, height: 30))
    iconContainerView.addSubview(iconView)
    leftView = iconContainerView
    leftViewMode = .always
  }
}
