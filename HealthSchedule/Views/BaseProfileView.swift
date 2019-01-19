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
  @IBOutlet weak var textFieldsContainerView: UIView!
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var surnameField: UITextField!
  @IBOutlet weak var ageField: UITextField!
  @IBOutlet weak var regionField: UITextField!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // TODO: round text fields
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setEditingStateTo(_ state: Bool) {
    nameField.isUserInteractionEnabled = state
    surnameField.isUserInteractionEnabled = state
    ageField.isUserInteractionEnabled = state
    regionField.isUserInteractionEnabled = state
  }
  
  class func instanceFromNib() -> BaseProfileView {
    return UINib(nibName: "ProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BaseProfileView
  }
  
  @IBAction func onSaveClick(_ sender: Any) {
    print("Clicked")
  }
}
