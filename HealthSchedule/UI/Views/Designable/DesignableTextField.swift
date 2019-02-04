//
//  DesignableTextField.swift
//  HealthSchedule
//
//  Created by sys-246 on 1/18/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {
  
  // Provides left padding for images
  override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.leftViewRect(forBounds: bounds)
    textRect.origin.x += leftPadding + 10
    return textRect
  }
  
  @IBInspectable var leftImage: UIImage? {
    didSet {
      updateView()
    }
  }
  
  @IBInspectable var leftPadding: CGFloat = 0
  
  @IBInspectable var color: UIColor = UIColor.lightGray {
    didSet {
      updateView()
    }
  }
  
  func updateView() {
    if let image = leftImage {
      leftViewMode = UITextField.ViewMode.always
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      imageView.tintColor = color
      leftView = imageView
    } else {
      leftViewMode = UITextField.ViewMode.never
      leftView = nil
    }
    
    // Placeholder text color
    attributedPlaceholder = NSAttributedString(
      string: placeholder != nil ?  placeholder! : "",
      attributes:[NSAttributedString.Key.foregroundColor: color])
  }
}
