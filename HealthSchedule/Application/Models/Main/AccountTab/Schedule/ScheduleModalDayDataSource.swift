//
//  ScheduleModalDayDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

enum ScheduleModalDaySectionsIdentifiers: Int {
  case start = 0
  case end = 1
  case status = 2
}

class ScheduleModalDayDataSource: NSObject {
  private var tableViewMasterDelegate: TableViewMasteringDelegate
  private var sectionsInfo: [ExpandableSectionData]
  
  subscript(index: Int) -> ExpandableSectionData {
    return sectionsInfo[index]
  }
  
  init(_ startDate: Date, tableViewMasterDelegate: TableViewMasteringDelegate) {
    self.tableViewMasterDelegate = tableViewMasterDelegate
    
    sectionsInfo = [
      ExpandableSectionData.init(
        section: ScheduleModalDaySectionsIdentifiers.start.rawValue,
        placeholder: "Start time:",
        display: DateManager.shared.date2String(with: .time, startDate, .hour24),
        isExpanded: false,
        rowsCount: 1
      ),
      ExpandableSectionData.init(
        section: ScheduleModalDaySectionsIdentifiers.end.rawValue,
        placeholder: "End time:",
        display: DateManager.shared.date2String(with: .time, DateManager.shared.getAvailableServiceTimeRange().max, .hour24),
        isExpanded: false,
        rowsCount: 1
      ),
      ExpandableSectionData.init(
        section: ScheduleModalDaySectionsIdentifiers.status.rawValue,
        placeholder: "Status:",
        display: "Working",
        isExpanded: false,
        rowsCount: 2
      )
    ]
    
    sectionsInfo[ScheduleModalDaySectionsIdentifiers.start.rawValue].containsDataOfType = .pickable
    sectionsInfo[ScheduleModalDaySectionsIdentifiers.end.rawValue].containsDataOfType = .pickable
    sectionsInfo[ScheduleModalDaySectionsIdentifiers.status.rawValue].containsDataOfType = .selectable
  }
}

extension ScheduleModalDayDataSource: ExandableHeaderViewDelegate {
  func toogleExpand(for header: UITableViewHeaderFooterView, section: Int) {
    sectionsInfo[section].isExpanded = !sectionsInfo[section].isExpanded
    
    guard let header = header as? ScheduleModalTableViewHader else {
      fatalError("Cannot cast to ScheduleModalTableViewHader in ScheduleModalDayDataSource")
    }
    
    header.data.isExpanded = sectionsInfo[section].isExpanded
    
    tableViewMasterDelegate.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
  }
}

extension ScheduleModalDayDataSource: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionsInfo.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !sectionsInfo[section].isExpanded {
      return 0
    }
    
    return sectionsInfo[section].rowsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch sectionsInfo[indexPath.section].containsDataOfType {
    case .selectable:
      guard let cell = tableViewMasterDelegate.dequeueReusableCell(identifier: ScheduleEventTableView.selectableCellIdentifier, for: indexPath) as? ScheduleModalTableViewSelectableRow else { fatalError("selectable cell fials")}
      
      return cell
    case .pickable:
      guard let cell = tableViewMasterDelegate.dequeueReusableCell(identifier: ScheduleEventTableView.timePickingCellIdentifier, for: indexPath) as? ScheduleModalTableViewDatePickerRow else { fatalError("pickable cell fials")}
      
      return cell
    case .common:
      fatalError("There is no common cell been registered!")
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableViewMasterDelegate.dequeueReusableHeader(identifier: ScheduleEventTableView.sectionIdentifier) as! ScheduleModalTableViewHader
    
    sectionsInfo[section].section = section
    header.data = sectionsInfo[section]
    header.collapseDelegate = self
    header.setDisplayInfo(sectionsInfo[section].dataPlaceholder, data: sectionsInfo[section].displayData)
    
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
}
