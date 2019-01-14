//
//  BaseProfileView.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class BaseProfileView: UIView {
  
  @IBOutlet weak var profileImageView: UIImageView!
  
  class func instanceFromNib() -> BaseProfileView {
    return UINib(nibName: "ProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BaseProfileView
  }
  
}
