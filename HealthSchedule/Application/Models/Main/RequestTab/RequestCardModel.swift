//
//  RequestCardModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardModel {
  let dataSource = RequestCardDataSource()
  
  func procceedRequest(_ request: RemoteRequest) {
    dataSource.data = [
      RequestCardProviderSectionModel(request: request),
      RequestCardScheduleSectionModel(request: request),
      RequestCardInfoSectionModel(request: request)
    ]
  }
}

class RequestCardDataSource: NSObject, UITableViewDataSource {
  fileprivate let commmonDataRequestController = CommonDataRequest()
  fileprivate var data: [RequestSectionDataContaining] = []
  
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
      
      loadImage(by: providerRowData.imageUrl) { image in
        DispatchQueue.main.async {
          cell.photoImage = image
        }
      }
      
      return cell
    }
    
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(rowData.title): \(rowData.data)"
    cell.selectionStyle = .none
    return cell
  }
  
  fileprivate func loadImage(by url: String?, _ completion: @escaping (UIImage) -> Void) {
    guard let url = url else {
      return
    }
    
    commmonDataRequestController.getImage(from: url) {
      data in
      
      guard let image = UIImage(data: data) else {
        return
      }
      
      completion(image)
    }
  }
}
