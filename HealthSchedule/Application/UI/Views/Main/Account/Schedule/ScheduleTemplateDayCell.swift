//
//  ScheduleTemplateDayCell.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/2/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FSCalendar

enum SelectionType : Int {
  case none
  case single
  case leftBorder
  case middle
  case rightBorder
}

class ScheduleTemplateDayCell: FSCalendarCell {
  weak var selectionLayer: CAShapeLayer!
    
  var selectionType: SelectionType = .none {
    didSet {
      setNeedsLayout()
    }
  }
  
  required init!(coder aDecoder: NSCoder!) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let selectionLayer = CAShapeLayer()
    selectionLayer.fillColor = UIColor.black.cgColor
    selectionLayer.actions = ["hidden": NSNull()]
    self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
    self.selectionLayer = selectionLayer
    
    self.shapeLayer.isHidden = true
    
    let view = UIView(frame: self.bounds)
    view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
    self.backgroundView = view;
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
    self.selectionLayer.frame = self.contentView.bounds
    
    if selectionType == .middle {
      self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
    }
    else if selectionType == .leftBorder {
      self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
    }
    else if selectionType == .rightBorder {
      self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
    }
    else if selectionType == .single {
      let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
      self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
    }
  }
  
  override func configureAppearance() {
    super.configureAppearance()
    if self.isSelected {
      self.backgroundView?.backgroundColor = UIColor.green.withAlphaComponent(0.12)
    } else {
      self.backgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
    }
    self.titleLabel.textColor = .black
  }
}
