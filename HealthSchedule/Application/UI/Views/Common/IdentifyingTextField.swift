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
  var subType: AccountRowSubtype = .none
  var aciton: (() -> Void)?
  
  override var delegate: UITextFieldDelegate? {
    get { return super.delegate }
    set { super.delegate = newValue }
  }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    let cutPasteActionType = action == #selector(UIResponderStandardEditActions.paste(_:))
      || action == #selector(UIResponderStandardEditActions.cut(_:))
    
    if subType == .datePicker && cutPasteActionType {
      return false
    }
    
    return super.canPerformAction(action, withSender: sender)
  }
}
