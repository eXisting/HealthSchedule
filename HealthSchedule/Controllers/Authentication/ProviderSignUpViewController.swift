//
//  DetailedSignUpViewController.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 1/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ProviderSignUpViewController: UIViewController {
  
  private let experienceMaxCount = 3
  
  private var experienceBlocks = [SelectWithExperienceView]()
    
  override func loadView() {
    super.loadView()
    loadViewsFromXib()
  }
  
  func loadViewsFromXib() {
    for _ in 0..<experienceMaxCount {
      let section: SelectWithExperienceView = UIView.instanceFromNib("SelectWithExperienceView")
      experienceBlocks.append(section)
    }
  }
}
