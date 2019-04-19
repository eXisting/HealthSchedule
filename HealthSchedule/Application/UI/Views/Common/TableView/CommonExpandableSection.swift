//
//  CommonExpandableSection.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/19/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

protocol DeletableHeaderDelegate {
  func deleteSection(section: Int)
}

class CommonExpandableSection: UITableViewHeaderFooterView {
  var data: ExpandableSectionData! {
    didSet {
      textLabel?.text = data.displayData
    }
  }
  
  var collapseDelegate: ExpandableHeaderViewDelegate!
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectHeader)))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func onSelectHeader(recognizer: UITapGestureRecognizer) {
    let cell = recognizer.view as! CommonExpandableSection
    collapseDelegate.toogleExpand(for: cell, section: cell.data.section)
  }
}
