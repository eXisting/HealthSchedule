//
//  SettingsViewController.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/14/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  // MARK: - Outlets
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    let profileView = BaseProfileView.instanceFromNib()
    
    profileView.setEditingStateTo(false)
    
    profileView.nameField.text = "John"
    profileView.surnameField.text = "Smith"
    profileView.ageField.text = "44"
    profileView.regionField.text = "Kharkiv"
        
    let placeholderImage = (RequestHandler.shared as ImageRequesting).getImage(from: "https://cdn1.iconfinder.com/data/icons/business-charts/512/customer-512.png")
    
    profileView.profileImageView.image = placeholderImage
    profileView.profileImageView.roundImageBy(divider: 3)
    
    profileView.frame = view.frame
    view.addSubview(profileView)
  }
}
