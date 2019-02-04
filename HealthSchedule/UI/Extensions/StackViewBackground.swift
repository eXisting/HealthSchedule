//
//  StackViewBackground.swift
//  HealthSchedule
//
//  Created by Andrey Popazov on 2/4/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

extension UIStackView {
  func addBackgroundView(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    insertSubview(view, at: 0)
    view.pin(to: self)
  }
}

extension UIView {
  func pin(to view: UIView) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topAnchor.constraint(equalTo: view.topAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }
}
