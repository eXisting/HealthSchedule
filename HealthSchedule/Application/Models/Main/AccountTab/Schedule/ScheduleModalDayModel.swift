//
//  ScheduleModalDayModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/8/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class ScheduleModalDayModel {
  var dataSource: ScheduleModalDayDataSource
  
  init(startDate: Date, saveDelegate: ScheduleNavigationItemDelegate, tableViewMasterDelegate: TableViewMasteringDelegate) {
    dataSource = ScheduleModalDayDataSource(startDate, saveDelegate: saveDelegate, tableViewMasterDelegate: tableViewMasterDelegate)
  }
}

class ScheduleModalDayDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  private var saveDelegate: ScheduleNavigationItemDelegate
  private var tableViewMasterDelegate: TableViewMasteringDelegate
  private var sectionsInfo: [ExpandableSectionData]
  
  init(_ startDate: Date, saveDelegate: ScheduleNavigationItemDelegate, tableViewMasterDelegate: TableViewMasteringDelegate) {
    self.saveDelegate = saveDelegate
    self.tableViewMasterDelegate = tableViewMasterDelegate
    
    sectionsInfo = [
      ExpandableSectionData.init(
        section: 0,
        placeholder: "Start time:",
        display: DateManager.shared.date2String(with: .time, startDate, .hour24),
        isExpanded: false,
        rowsCount: 1
      ),
      ExpandableSectionData.init(
        section: 1,
        placeholder: "End time:",
        display: DateManager.shared.date2String(with: .time, DateManager.shared.getAvailableServiceTimeRange().max, .hour24),
        isExpanded: false,
        rowsCount: 1
      ),
      ExpandableSectionData.init(
        section: 2,
        placeholder: "Status:",
        display: "Working",
        isExpanded: false,
        rowsCount: 2
      )
    ]
    
    sectionsInfo[0].containsDataOfType = .pickable
    sectionsInfo[1].containsDataOfType = .pickable
    sectionsInfo[2].containsDataOfType = .selectable
  }
  
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
