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
  
  // Provides left padding for images
  override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.leftViewRect(forBounds: bounds)
    textRect.origin.x += leftPadding
    return textRect
  }
  
  func updateView() {
    if let image = leftImage {
      leftViewMode = .always
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      imageView.tintColor = color
      leftView = imageView
    } else {
      leftViewMode = .never
      leftView = nil
    }
    
    // Placeholder text color
    attributedPlaceholder = NSAttributedString(
      string: placeholder != nil ?  placeholder! : "",
      attributes:[NSAttributedString.Key.foregroundColor: color])
  }
}
