//
//  SystemExtensions.swift
//  HealthSchedule
//
//  Created by sys-246 on 2/1/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

extension String {
  
  /// Percent escapes values to be added to a URL query as specified in RFC 3986
  ///
  /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
  ///
  /// http://www.ietf.org/rfc/rfc3986.txt
  ///
  /// - returns: Returns percent-escaped string.
  
  func addingPercentEncodingForURLQueryValue() -> String? {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    
    var allowed = CharacterSet.urlQueryAllowed
    allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
    
    return addingPercentEncoding(withAllowedCharacters: allowed)
  }
  
}

extension Dictionary where Key == String, Value == String {
  
  // Shortcut for parsing dictionary as params string
  
  func asParamsString() -> String {
    return "?\(self.asDataString())"
  }
  
  func asDataString() -> String {
    let parameterArray = map { key, value -> String in
      let percentEscapedKey = key.addingPercentEncodingForURLQueryValue()!
      let percentEscapedValue = value.addingPercentEncodingForURLQueryValue()!
      return "\(percentEscapedKey)=\(percentEscapedValue)"
    }
    
    return parameterArray.joined(separator: "&")
  }
}

protocol LayoutGuideProvider {
  var leadingAnchor: NSLayoutXAxisAnchor { get }
  var trailingAnchor: NSLayoutXAxisAnchor { get }
  var leftAnchor: NSLayoutXAxisAnchor { get }
  var rightAnchor: NSLayoutXAxisAnchor { get }
  var topAnchor: NSLayoutYAxisAnchor { get }
  var bottomAnchor: NSLayoutYAxisAnchor { get }
  var widthAnchor: NSLayoutDimension { get }
  var heightAnchor: NSLayoutDimension { get }
  var centerXAnchor: NSLayoutXAxisAnchor { get }
  var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuideProvider { }
extension UILayoutGuide: LayoutGuideProvider { }

extension UIView {
  var compatibleSafeAreaLayoutGuide: LayoutGuideProvider {
    if #available(iOS 11, *) {
      return safeAreaLayoutGuide
    } else {
      return self
    }
  }
}

extension UITextField {
  func setIcon(_ image: UIImage) {
    let iconView = UIImageView(frame:
      CGRect(x: 10, y: 5, width: 20, height: 20))
    iconView.image = image
    let iconContainerView: UIView = UIView(frame:
      CGRect(x: 20, y: 0, width: 30, height: 30))
    iconContainerView.addSubview(iconView)
    leftView = iconContainerView
    leftViewMode = .always
  }
}
