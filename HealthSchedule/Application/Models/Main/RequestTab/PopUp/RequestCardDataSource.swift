//
//  RequestCardDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/22/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardDataSource: NSObject, UITableViewDataSource {
  typealias ProcessingFunction = (String?, @escaping (UIImage) -> Void) -> Void
  var imageProcessing: ProcessingFunction!
  
  private var data: [RequestSectionDataContaining] = []
  
  init(_ request: Request) {
    data = [
      RequestCardProviderSectionModel(request: request),
      RequestCardScheduleSectionModel(request: request),
      RequestCardInfoSectionModel(request: request)
    ]
  }
  
  subscript(forSectionIndex: Int) -> RequestSectionDataContaining {
    return data[forSectionIndex]
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rowData = data[indexPath.section][indexPath.row]
    
    if let providerRowData = rowData as? RequestCardProviderRowModel {
      let cell = tableView.dequeueReusableCell(withIdentifier: RequestCardTableView.cellIdentifier, for: indexPath) as! RequestCardImageRow
      cell.populateCell(name: providerRowData.data)
      
      imageProcessing(providerRowData.imageUrl) { image in
        DispatchQueue.main.async {
          cell.photoImage = image
        }
      }
      
      return cell
    }
    
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(rowData.title): \(rowData.data)"
    cell.textLabel?.numberOfLines = 10
    cell.textLabel?.lineBreakMode = .byWordWrapping
    cell.selectionStyle = .none
    return cell
  }
}
