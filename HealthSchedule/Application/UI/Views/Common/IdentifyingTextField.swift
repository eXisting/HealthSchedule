//
//  IdentifyingTextField.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class IdentifyingTextField: UITextField {
  var identifier: IndexPath?
  
  override var delegate: UITextFieldDelegate? {
    get { return super.delegate }
    set { super.delegate = newValue }
  }
}
