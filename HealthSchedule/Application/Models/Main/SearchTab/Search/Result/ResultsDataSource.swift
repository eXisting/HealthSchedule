//
//  SearchResultDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/15/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit
import FoldingCell

class ResultsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  private var data: [ResultSectionModel] = []
  private var cellModels: [ProviderSearchViewModel]
  
  private var sendRequestHandler: ((Int, Date) -> Void)!
    
  var reloadDelegate: TableViewSectionsReloading!
  var loaderDelegate: LoaderShowable!
  var viewDetailsDelegate: PushingUserControllerDelegate!
  var service: Service!
  
  init(dataModels: [ResultSectionModel], sendRequestHandler: @escaping (Int, Date) -> Void) {
    self.sendRequestHandler = sendRequestHandler
    
    data = dataModels
    
    cellModels = [ProviderSearchViewModel].init(repeating: ProviderSearchViewModel(), count: data.count)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return data[section].sectionHeight
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionData = data[section]
    
    var totalNumberOfRows = 0
    for rowIndex in 0..<sectionData.getNumberOfRows() {
      totalNumberOfRows += sectionData.rows[rowIndex].userIds.count
    }
    
    return totalNumberOfRows
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // WARNING: Throws for multiple providers per time
    return data[indexPath.section].rows[indexPath.row].rowHeight
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return data[section].sectionName
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultView.headerReuseIdentifier) as! CommonExpandableSection

    let sectionData = data[section]
    
    header.data = ExpandableSectionData(
      section: section,
      placeholder: "",
      display: sectionData.sectionName,
      isExpanded: sectionData.isExpanded,
      rowsCount: sectionData.numberOfRows
    )

    header.collapseDelegate = self

    return header
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let itemAndSubsectionIndex = computeItemAndSubsectionIndex(for: indexPath)
    
    let subsectionIndex = itemAndSubsectionIndex.section
    let itemIndex = itemAndSubsectionIndex.row
    
    let sectionData = data[indexPath.section]
    let rowData = sectionData.rows[subsectionIndex]
    
    if itemIndex < 0 {
      // Section header
      let cell = UITableViewCell()
      cell.selectionStyle = .none
      cell.textLabel?.text = DateManager.shared.date2String(with: .time, rowData.time, .hour24)
      return cell
    } else {
      // Row Item
      let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultView.cellReuseIdentifier, for: indexPath) as! SearchResultFoldingCell
      
      cell.setupCollapsedView(delegate: cellModels[itemIndex].dataSource, dataSource: cellModels[itemIndex].dataSource, identifier: indexPath, onViewDetails: onViewDetailsClick)
      
      if data[indexPath.section].rows[indexPath.row].rowHeight == cell.collapsedHeight { // isClosed cell
        cell.setupDisplayTime("UserID: \(rowData.userIds[itemIndex])")
      }
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? SearchResultFoldingCell else {
      return
    }
    
    let itemAndSubsectionIndex = computeItemAndSubsectionIndex(for: indexPath)
    let subsectionIndex = itemAndSubsectionIndex.section
    let itemIndex = itemAndSubsectionIndex.row
    
    let userId = data[indexPath.section].rows[subsectionIndex].userIds[itemIndex]
    
    cell.isUserInteractionEnabled = false
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      if self!.data[indexPath.section].rows[indexPath.row].rowHeight == cell.collapsedHeight { // open cell
        DispatchQueue.main.async {
          self?.loaderDelegate.showLoader()
        }
        
        self!.cellModels[itemIndex].setupProviderCard(with: userId, for: self!.service) { [weak self] isProcessed in
          self?.data[indexPath.section].rows[indexPath.row].changeHeight(to: cell.maxHeight)
          
          DispatchQueue.main.async {
            cell.unfold(true, animated: true, completion: {
              cell.isUserInteractionEnabled = true
              tableView.reloadRows(at: [indexPath], with: .automatic)
            })
            
            self?.loaderDelegate.hideLoader()
          }
        }
      } else { // close cell
        self!.data[indexPath.section].rows[indexPath.row].changeHeight(to: cell.collapsedHeight)
        DispatchQueue.main.async {
          cell.unfold(false, animated: true, completion: {
            cell.isUserInteractionEnabled = true
            tableView.reloadRows(at: [indexPath], with: .automatic)
          })
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? SearchResultFoldingCell else {
      return
    }
    
    if data[indexPath.section].rows[indexPath.row].rowHeight == cell.collapsedHeight {
      cell.unfold(false, animated: false, completion:nil)
      cell.reloadTableView()
    } else {
      cell.unfold(true, animated: false, completion: nil)
      cell.reloadTableView()
    }
  }
  
  // MARK: Handlers
  
  private func onViewDetailsClick(_ identity: IndexPath) {
    let subSectionItemIndexPath = computeItemAndSubsectionIndex(for: identity)
    
    let section = identity.section
    let subSection = subSectionItemIndexPath.section
    let row = subSectionItemIndexPath.row
    
    let sectionData = data[identity.section]
    let rowData = sectionData.rows[subSection]
    
    let providerId = rowData.userIds[row]
    let choosenTime = data[section].rows[subSection].time
    let chosenDate = DateManager.shared.stringToDate(data[section].sectionName, format: .date)
    
    guard let bookingTime = DateManager.shared.combineDateWithTime(date: chosenDate, time: choosenTime) else {
      fatalError()
    }
    
    viewDetailsDelegate.pushController(with: providerId, serviceId: Int(service.id), time: bookingTime)
  }
  
  private func computeItemAndSubsectionIndex(for indexPath: IndexPath?) -> IndexPath {
    var sectionItems = data[Int(indexPath?.section ?? 0)]
    var itemIndex: Int = indexPath?.row ?? 0
    var subsectionIndex: Int = 0
    
    for i in 0..<sectionItems.getNumberOfRows() {
      // First row for each section item is header
      itemIndex -= 1
      
      // Check if the item index is within this subsection's items
      let subsectionItems = sectionItems.rows[i]
      if itemIndex < subsectionItems.userIds.count {
        subsectionIndex = i
        break
      } else {
        itemIndex -= subsectionItems.userIds.count
      }
    }
    
    return IndexPath(row: itemIndex, section: subsectionIndex)
  }
}

extension ResultsDataSource: ExpandableHeaderViewDelegate {
  func toogleExpand(for header: UITableViewHeaderFooterView, section: Int) {
    let expandableHeader = header as! CommonExpandableSection
    
    data[section].isExpanded = !data[section].isExpanded
    expandableHeader.data.isExpanded = data[section].isExpanded
    
    reloadDelegate.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
  }
}
