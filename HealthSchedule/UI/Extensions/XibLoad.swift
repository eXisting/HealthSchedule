//
//  XibLoad.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/28/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

extension UIView {
  class func instanceFromNib<T>(_ nibName: String) -> T {
    return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
  }
}
