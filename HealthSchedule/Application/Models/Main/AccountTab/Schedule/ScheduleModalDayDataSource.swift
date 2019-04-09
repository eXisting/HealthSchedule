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

enum ScheduleModalStatusIndexes: Int {
  case working = 0
  case off = 1
}

class ScheduleModalDayDataSource: NSObject {
  private var tableViewMasterDelegate: TableViewMasteringDelegate!
  private var sectionsInfo: [ExpandableSectionData]!
  private var rowsInfo: [SelectableRowsData]!
  
  private lazy var timeRange = DateManager.shared.getAvailableServiceTimeRange()
  
  subscript(index: Int) -> ExpandableSectionData {
    return sectionsInfo[index]
  }
  
  init(_ startDate: Date, tableViewMasterDelegate: TableViewMasteringDelegate, _ endDate: Date?, _ status: WorkingStatus) {
    super.init()
    
    self.tableViewMasterDelegate = tableViewMasterDelegate
    
    let end = endDate ?? DateManager.shared.getAvailableServiceTimeRange().max
    let start = DateManager.shared.date2String(with: .time, startDate, .hour24)
    
    rowsInfo = [
      SelectableRowsData.init(
        section: ScheduleModalDaySectionsIdentifiers.start.rawValue,
        data: getStatusName(for: ScheduleModalStatusIndexes.working.rawValue),
        checkedState: status == .working ? true : false
      ),
      SelectableRowsData.init(
        section: ScheduleModalDaySectionsIdentifiers.start.rawValue,
        data: getStatusName(for: ScheduleModalStatusIndexes.off.rawValue),
        checkedState: status == .off ? true : false
      )
    ]
    
    sectionsInfo = [
      ExpandableSectionData.init(
        section: ScheduleModalDaySectionsIdentifiers.start.rawValue,
        placeholder: "Start time:",
        display: start,
        isExpanded: false,
        rowsCount: 1
      ),
      ExpandableSectionData.init(
        section: ScheduleModalDaySectionsIdentifiers.end.rawValue,
        placeholder: "End time:",
        display: DateManager.shared.date2String(with: .time, end, .hour24),
        isExpanded: false,
        rowsCount: 1
      ),
      ExpandableSectionData.init(
        section: ScheduleModalDaySectionsIdentifiers.status.rawValue,
        placeholder: "Status:",
        display: status.rawValue,
        isExpanded: false,
        rowsCount: 2
      )
    ]
    
    sectionsInfo[ScheduleModalDaySectionsIdentifiers.start.rawValue].containsDataOfType = .pickable
    sectionsInfo[ScheduleModalDaySectionsIdentifiers.end.rawValue].containsDataOfType = .pickable
    sectionsInfo[ScheduleModalDaySectionsIdentifiers.status.rawValue].containsDataOfType = .selectable
  }
  
  private func getStatusName(for index: Int) -> String {
    return index == ScheduleModalStatusIndexes.working.rawValue ?
      WorkingStatus.working.rawValue : WorkingStatus.off.rawValue
  }
  
  private func processChecking(_ tableView: UITableView, for indexPath: IndexPath) {
    for index in 0..<rowsInfo.count {
      let loopIndexPath = IndexPath(row: index, section: indexPath.section)
      
      guard let cell = tableView.cellForRow(at: loopIndexPath) as? ScheduleModalTableViewSelectableRow else {
        rowsInfo[index].checkedState = false
        continue
      }
      
      let isChecked = loopIndexPath == indexPath
      
      var accessoryType = UITableViewCell.AccessoryType.none
      
      if isChecked {
        accessoryType = .checkmark
      }
      
      cell.accessoryType = accessoryType
      rowsInfo[index].checkedState = isChecked
    }
    
    let isWorkingChecked = rowsInfo[ScheduleModalStatusIndexes.working.rawValue].checkedState
    sectionsInfo[indexPath.section].displayData = isWorkingChecked ?
      WorkingStatus.working.rawValue : WorkingStatus.off.rawValue
    
    tableViewMasterDelegate.redrawSection(indexPath)
  }
  
  private func onDateChanged(newDate: Date, for indexPath: IndexPath) {
    rowsInfo[indexPath.row].data = DateManager.shared.date2String(with: .time, newDate, .hour24)
    sectionsInfo[indexPath.section].displayData = rowsInfo[indexPath.row].data
    tableViewMasterDelegate.redrawSection(indexPath)
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
      
      cell.setup(getStatusName(for: indexPath.row), identifier: indexPath)
      
      if rowsInfo[indexPath.row].checkedState {
        cell.accessoryType = .checkmark
      }
      
      return cell
    case .pickable:
      guard let cell = tableViewMasterDelegate.dequeueReusableCell(identifier: ScheduleEventTableView.timePickingCellIdentifier, for: indexPath) as? ScheduleModalTableViewDatePickerRow else { fatalError("pickable cell fials")}
      
      cell.setup(identifier: indexPath, onValueChangedHandler: onDateChanged)
      cell.set(dateToDisplay: sectionsInfo[indexPath.section].displayData, datesRange: timeRange)
      
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cellGroup = ScheduleModalDaySectionsIdentifiers(rawValue: indexPath.section) else {
      fatalError()
    }
    
    if cellGroup == .status {
      processChecking(tableView, for: indexPath)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let cellGroup = ScheduleModalDaySectionsIdentifiers(rawValue: indexPath.section) else {
      fatalError()
    }
    
    return cellGroup == .status ? 40 : 160
  }
}
