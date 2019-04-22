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
  
  var dataSource: RequestCardDataSource
  
  init(request: Request) {
    self.request = request
    
    dataSource = RequestCardDataSource(request)
    dataSource.imageProcessing = loadImage
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
    return dataSource[forSectionIndex]
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
