//
//  ExpandableSectionData.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum GeneralSectionDataContaining {
  case selectable
  case pickable
  case common
}

protocol GeneralDataContaining {
  var containsDataOfType: GeneralSectionDataContaining { get set }
}

struct ExpandableSectionData {
  var section: Int
  var dataPlaceholder: String
  var displayData: String
  var isExpanded: Bool
  var rowsCount: Int
  
  init(section: Int, placeholder: String, display: String, isExpanded: Bool, rowsCount: Int) {
    self.section = section
    self.dataPlaceholder = placeholder
    self.displayData = display
    self.isExpanded = isExpanded
    self.rowsCount = rowsCount
  }
  
  private var allRowsOfType: GeneralSectionDataContaining?
}

extension ExpandableSectionData: GeneralDataContaining {
  var containsDataOfType: GeneralSectionDataContaining {
    get { return allRowsOfType ?? .common }
    set { allRowsOfType = newValue }
  }
}
