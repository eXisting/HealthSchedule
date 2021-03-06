//
//  RequestCardModel.swift
//  HealthSchedule
//
//  Created by sys-246 on 3/20/19.
//  Copyright © 2019 sys-246. All rights reserved.
//

import UIKit

class RequestCardModel {
  private let commmonDataRequestController = CommonDataRequest()
  private let requestManager: UserDataUpdating = UserDataRequest()
  private var request: Request
  
  let dataSource = RequestCardDataSource()
  
  init(request: Request) {
    self.request = request
    dataSource.imageProcessing = loadImage
    
    procceedRequest()
  }
  
  func isRequestHasActions() -> Bool {
    let requestStatus = ReqeustStatus.statusValue2RequestStatusName(value: Int(request.status))
    return requestStatus == .pending || requestStatus == .accepted
  }
  
  func getCurrentUserRole() -> Role {
    guard let user = DataBaseManager.shared.fetchRequestsHandler.getCurrentUser(context: DataBaseManager.shared.mainContext) else {
      fatalError("Cannot get user from Core Data while being logged in...")
    }
    
    guard let role = user.role else { fatalError("App user must have a role attached to him!") }
    
    return role
  }
  
  func updateRequest(status: RequestStatusName) {
    let postData: Parser.JsonDictionary = [
      RequestJsonFields.status.rawValue: String(ReqeustStatus.statusName2RValue(value: status))
    ]
    
    requestManager.updateRequest(id: Int(request.id), with: postData) { response in
      // THE GIVEN DATA WAS INVALID
      
      // TODO: Call reload cell
      
      print(response)
    }
  }
  
  subscript(forSectionIndex: Int) -> RequestSectionDataContaining {
    return dataSource.data[forSectionIndex]
  }
  
  private func procceedRequest() {
    dataSource.data = [
      RequestCardProviderSectionModel(request: request),
      RequestCardScheduleSectionModel(request: request),
      RequestCardInfoSectionModel(request: request)
    ]
  }
  
  private func loadImage(by url: String?, _ completion: @escaping (UIImage) -> Void) {
    guard let url = url else {
      return
    }
    
    commmonDataRequestController.getImage(from: url) { data in
      guard let image = UIImage(data: data) else {
        return
      }
      
      completion(image)
    }
  }
}

class RequestCardDataSource: NSObject, UITableViewDataSource {
  fileprivate typealias ProcessingFunction = (String?, @escaping (UIImage) -> Void) -> Void
  
  fileprivate var data: [RequestSectionDataContaining] = []
  fileprivate var imageProcessing: ProcessingFunction!
  
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
