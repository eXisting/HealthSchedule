//
//  RequestCardDataSource.swift
//  HealthSchedule
//
//  Created by sys-246 on 4/22/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardDataSource: NSObject, UITableViewDataSource {
  typealias ProcessingFunction = (String, @escaping (UIImage) -> Void) -> Void
  var imageProcessing: ProcessingFunction
  var errorDelegate: ErrorShowable
  
  private var data: [RequestSectionDataContaining] = []
  
  init(_ request: Request, imageLoader: @escaping ProcessingFunction, errorDelegate: ErrorShowable) {
    self.errorDelegate = errorDelegate
    imageProcessing = imageLoader
    
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
    
    if let imageContainingData = rowData as? RequestCardUserRowModel {
      let cell = tableView.dequeueReusableCell(withIdentifier: RequestCardTableView.cellIdentifier, for: indexPath) as! RequestCardImageRow
      
      initialize(cell, with: imageContainingData)
      
      return cell
    }
    
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(rowData.title): \(rowData.data)"
    cell.textLabel?.numberOfLines = 10
    cell.textLabel?.lineBreakMode = .byWordWrapping
    cell.selectionStyle = .none
    return cell
  }
  
  private func initialize(_ cell: RequestCardImageRow, with imageContainingData: RequestCardUserRowModel) {
    cell.populateCell(name: imageContainingData.data)
    
    guard let imageUrl = imageContainingData.imageUrl else { return }
    
    if let cachedImage = CacheManager.shared.getFromCache(by: imageUrl as AnyObject) as? UIImage {
      // Should perfrom on another thread in order to not reload row
      DispatchQueue.global(qos: .userInteractive).async {
        DispatchQueue.main.async {
          cell.setImage(cachedImage)
        }
      }
      
      return
    }
    
    
    imageProcessing(imageUrl) { image in
      DispatchQueue.main.async {
        CacheManager.shared.saveToCache(imageUrl as AnyObject, image)
        cell.setImage(image)
      }
    }
  }
}
