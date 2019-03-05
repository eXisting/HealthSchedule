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
  
  let imageSize: CGFloat = 30.0
  
  override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.leftViewRect(forBounds: bounds)
    textRect.origin.x += leftPadding;
    return textRect;
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: imageSize + leftPadding * 2, bottom: 0, right: 15))
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: imageSize + leftPadding * 2, bottom: 0, right: 15))
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: imageSize + leftPadding * 2, bottom: 0, right: 15))
  }
  
  @IBInspectable var leftImage: UIImage? {
    didSet {
      updateView()
    }
  }
  
  @IBInspectable var leftPadding: CGFloat = 0
  
  @IBInspectable var color: UIColor = UIColor.white {
    didSet {
      updateView()
    }
  }
  
  func updateView() {
    if let image = leftImage {
      leftViewMode = UITextField.ViewMode.always
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      imageView.changeColor(to: color)
      leftView = imageView
    } else {
      leftViewMode = UITextField.ViewMode.never
      leftView = nil
    }
  }
}
